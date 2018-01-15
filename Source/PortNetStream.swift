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


/**
 */
class PortNetStream: PortNet, EndpointDelegate {
    
    // MARK: - Private
    private enum State {
        case closed
        case Connecting
        case Open
    }

    private static let bufferSize = 8192
    private var        state      = State.closed
    private var        oqueue     = [UInt8]()
    private var        buffer     = Data(repeating: 0, count: bufferSize)
    
    // MARK: - Initializers
    
    override init(address: SockAddr)
    {
        assert(address.proto == .tcp)
        
        super.init(address: address)
    }
    
    init(endpoint: EndpointNet)
    {
        assert(endpoint.hostAddress!.proto == .tcp)
        
        super.init(address: endpoint.hostAddress!)
        
        self.endpoint = endpoint
        endpoint.delegate = self
    }
    
    // MARK: - Lifecycle
    
    override public func shutdown(for reason: Error?)
    {
        close(for: reason)
    }
    
    override public func start()
    {
        guard(state == .closed) else { return }
        
        if endpoint == nil {
            endpoint = EndpointNet()
            endpoint.delegate = self
            
            state = .Connecting
            if !endpoint.connect(address: address) {
                close(for: nil)
            }
        }
        else {
            initialized(with: nil)
        }
    }
    
    // MARK: - Output
 
    /**
     Send data.
     */
    override public func send(_ data: Data)
    {
        guard(state == .Open) else { return }
        
        oqueue += data
        send()
    }
    
    // MARK: - Internal
    
    private func close(for reason: Error?)
    {
        guard(state != .closed) else { return }
        
        endpoint.close()
        state = .closed
        
        if let delegate = self.delegate {
            DispatchQueue.main.async { delegate.portDidClose(self, for: reason) }
        }
    }
    
    private func initialized(with error: Error?)
    {
        if error == nil {
            state = .Open
            endpoint.resumeIn()
        }
        else {
            state = .closed
            endpoint.close()
        }
    
        delegate?.portDidInitialize(self, with: error)
    }
    
    /**
     Receive handler.
     */
    private func receive()
    {
        var count: Int
        
        count = endpoint.receive(&buffer)
        while count > 0 {
            delegate?.port(self, didReceive: buffer.subdata(in: 0..<count))
            count = endpoint.receive(&buffer)
        }

        switch count {
        case Endpoint.closed :
            close(for: nil)
            
        case Endpoint.failed :
            close(for: nil)
            
        case Endpoint.wouldBlock :
            endpoint.resumeIn()

        default :
            close(for: nil)
        }
    }
    
    /**
     Send handler.
     */
    private func send()
    {
        var count = Int()
        
        while !oqueue.isEmpty {
            
            count = endpoint.send(Data(oqueue))
            if count <= 0 {
                break
            }
            
            oqueue.removeFirst(count)
        }
        
        if !oqueue.isEmpty {
            switch count {
            case Endpoint.wouldBlock :
                endpoint.resumeOut()
                
            default :
                shutdown(for: nil)
            }
        }
    }

    // MARK: - EndpointDelegate
    
    func endpointDidConnect(_ endpoint: Endpoint, with error: Error?)
    {
        initialized(with: error)
    }
    
    func endpointIn(_ endpoint: Endpoint)
    {
        receive()
    }
    
    func endpointOut(_ endpoint: Endpoint)
    {
        send()
    }
    
}


// End of File
