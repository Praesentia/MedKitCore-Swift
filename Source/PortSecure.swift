/*
 -----------------------------------------------------------------------------
 This source file is part of MedKitCore.
 
 Copyright 2016-2018 Jon Griffeth
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 -----------------------------------------------------------------------------
 */


import Foundation
import SecurityKit


/**
 Secure streaming port.

 Provides TLS encryption for the data stream.
 */
public class PortSecure: Port, PortDelegate, TLSDataStream {

    // MARK: - Properties
    public weak var delegate : PortDelegate?
    public let      context  : TLS

    // MARK: - Private Properties
    private var buffer  = Data(repeating: 0, count: 8192)
    private let input   = DataQueue()
    private let mode    : ProtocolMode
    private let port    : Port

    // MARK: - Initializers

    public init(port: Port, mode: ProtocolMode)
    {
        self.port    = port
        self.mode    = mode
        self.context = TLSFactoryShared.main.instantiate(mode: mode.tlsMode)

        port.delegate  = self
        context.stream = self
    }

    // MARK: - Lifecycle

    public func shutdown(for reason: Error?)
    {
        port.shutdown(for: reason)
    }

    public func start()
    {
        port.start()
    }

    // MARK: - Output

    public func send(_ data: Data)
    {
        if context.state == .connected {
            var dataLength = Int(0)

            let error = context.write(data, &dataLength)
            if error != nil {
                close(for: error)
            }
        }
    }

    // MARK: - Private

    /**
     Session handshake aborted.
     */
    private func aborted(for reason: Error?)
    {
        delegate?.portDidInitialize(self, with: reason)
        shutdown(for: reason)
    }

    /**
     Close session.
     */
    private func close(for reason: Error?)
    {
        let _ = context.shutdown()
        input.clear()
        shutdown(for: reason)
    }

    /**
     Handshake

     - Precondition:
         context != nil
         context.state == .idle || context.state == .handshake
     */
    private func initialize()
    {
        let error = context.start() as? SecurityKitError

        if error == nil {
            delegate?.portDidInitialize(self, with: nil)
        }
        else {
            if error! != .wouldBlock {
                aborted(for: error)
            }
        }
    }

    /**
     Handshake

     - Precondition:
         context != nil
         context.state == .idle || context.state == .handshake
     */
    private func handshake()
    {
        var ok = true

        while ok {
            let error = context.handshake() as? SecurityKitError

            if error == nil {
                ok = false
                delegate?.portDidInitialize(self, with: nil)
            }
            else {
                switch error! {
                case .wouldBlock :
                    ok = false

                default : // anything else is fatal
                    ok = false
                    aborted(for: error)
                }
            }
        }
    }

    /**
     Read data from context.

     - Precondition:
         context.state == .connected
     */
    private func read()
    {
        var ok = true

        while ok {
            var dataLength = buffer.count
            let error      = context.read(&buffer, &dataLength)

            if error == nil {
                delegate?.port(self, didReceive: buffer.subdata(in: 0..<dataLength))
            }
            else {
                switch error as! SecurityKitError {
                case .wouldBlock :
                    ok = false

                default :
                    ok = false
                    port.shutdown(for: error)
                }
            }
        }
    }

    // MARK: - TLSDataStream

    /**
     Read data.

     - Parameters:
         - context:    The TLS context from which the calling being made.
         - dataLength: The maximum number of bytes to be read.
     */
    public func tlsRead(_ context: TLS, _ count: Int) -> (data: Data?, error: Error?)
    {
        var data  : Data?
        var error : Error? = SecurityKitError.wouldBlock

        if input.count >= count {
            data  = Data(input.read(count: count))
            error = nil
        }

        return (data, error)
    }

    /**
     Write data.
     */
    public func tlsWrite(_ context: TLS, _ data: Data) -> (count: Int?, error: Error?)
    {
        port.send(data)
        return (data.count, nil)
    }

    // MARK: - PortDelegate

    /**
     Port did close.
     */
    public func portDidClose(_ port: Port, for reason: Error?)
    {
        let _ = context.shutdown()
        input.clear()
        delegate?.portDidClose(self, for: reason)
    }

    /**
     Port did initialize.
     */
    public func portDidInitialize(_ port: Port, with error: Error?)
    {
        if error == nil {
            initialize()
        }
        else {
            delegate?.portDidInitialize(self, with: error)
        }
    }

    /**
     Port did receive data.
     */
    public func port(_ port: Port, didReceive data: Data)
    {
        input.append(data)

        switch context.state {
        case .aborted :    // not expected here, but otherwise fatal
            aborted(for: SecurityKitError.failed)

        case .closed :     // spurious input
            input.clear()

        case .connected :  // normal read state
            read()

        case .handshake :  // handshake in progress
            handshake()

        case .idle :       // not expected here, but otherwise benign
            break
        }
    }

}


// End of File
