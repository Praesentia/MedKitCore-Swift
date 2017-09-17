/*
 -----------------------------------------------------------------------------
 This source file is part of MedKitCore.
 
 Copyright 2016-2017 Jon Griffeth
 
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
 */
public class PortSecure: Port, PortDelegate, TLSDataStream {

    // MARK: - Properties
    public weak var delegate : PortDelegate?
    public var      tls      : TLS

    // MARK: - Private Properties
    private var buffer  = Data(repeating: 0, count: 8192)
    private let input   = DataQueue()
    private let mode    : ProtocolMode
    private let port    : MedKitCore.Port

    // MARK: - Initializers

    public init(port: Port, mode: ProtocolMode)
    {
        self.port  = port
        self.mode  = mode
        self.tls   = TLSFactoryShared.main.instantiate(mode: mode.tlsMode)

        port.delegate = self
        tls.stream    = self
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
        if tls.state == .connected {
            var dataLength = Int(0)

            let error = tls.write(data, &dataLength)
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
        let _ = tls.close()
        input.clear()
        shutdown(for: reason)
    }

    /**
     Handshake

     - Precondition:
         tls != nil
         tls.state == .idle || tls.state == .handshake
     */
    private func handshake()
    {
        var ok = true

        while ok {
            let error = tls.handshake() as? SecurityKitError

            print("Handshake \(error)")

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
     Read data from tls.

     - Precondition:
         tls.state == .connected
     */
    private func read()
    {
        var ok = true

        while ok {
            var dataLength = buffer.count
            let error     = tls.read(&buffer, &dataLength)

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

    // MARK: - TLSStream

    /**
     Read
     */
    public func tlsRead(_ tls: TLS, _ data: UnsafeMutableRawBufferPointer, _ dataLength: inout Int) -> Error?
    {
        var error: Error? = SecurityKitError.wouldBlock

        if !input.isEmpty {
            let count = min(input.count, UInt64(dataLength))
            let bytes = input.read(count: Int(count))

            for i in 0..<bytes.count {
                data[i] = bytes[i]
            }

            if bytes.count == dataLength {
                error = nil
            }
            dataLength = bytes.count
        }
        else {
            dataLength = 0
        }

        return error
    }

    /**
     Write
     */
    public func tlsWrite(_ tls: TLS, _ data: Data, _ dataLength: inout Int) -> Error?
    {
        port.send(data)
        dataLength = data.count
        return nil
    }

    // MARK: - PortDelegate

    /**
     Port did close.
     */
    public func portDidClose(_ port: MedKitCore.Port, for reason: Error?)
    {
        let _ = tls.close()
        input.clear()
        delegate?.portDidClose(self, for: reason)
    }

    /**
     Port did initialize.
     */
    public func portDidInitialize(_ port: MedKitCore.Port, with error: Error?)
    {
        if error == nil {
            handshake()
        }
        else {
            delegate?.portDidInitialize(self, with: error)
        }
    }

    /**
     Port did receive data.
     */
    public func port(_ port: MedKitCore.Port, didReceive data: Data)
    {
        input.append(data)

        switch tls.state {
        case .idle :       // not expected here, but otherwise benign
            break

        case .handshake :  // handshake in progress
            handshake()

        case .aborted :    // TODO: when is this seen?
            aborted(for: nil)

        case .connected : // normal read state
            read()

        case .closed :    // spurious input
            input.clear()
        }
    }

}


// End of File
