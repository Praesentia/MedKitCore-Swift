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


import Foundation;


/**
 */
class PortNetTCP: PortNet, EndpointDelegate {
    
    // MARK: - Private
    private enum State {
        case Closed;
        case Connecting;
        case Open
    }

    private var state    = State.Closed;
    private var oqueue   = [UInt8]();
    private var buffer   = Data(repeating: 0, count: 4096);
    
    override init(address: SockAddr)
    {
        super.init(address: address);
    }
    
    init(endpoint: EndpointNet)
    {
        super.init(address: endpoint.hostAddress!);
        
        self.endpoint = endpoint;
        endpoint.delegate = self;
    }
 
    /**
     Send data.
     */
    override public func send(_ data: Data)
    {
        guard(state == .Open) else { return; }
        
        oqueue += data;
        send();
    }
    
    override public func shutdown(reason: Error?)
    {
        close(reason);
    }
    
    override public func start()
    {
        guard(state == .Closed) else { return; }

        if endpoint == nil {
            endpoint = EndpointNet();
            endpoint.delegate = self;

            state = .Connecting;
            if !endpoint.connect(address: address) {
                close(nil);
            }
        }
        else {
            initialized(with: nil);
        }
    }
    
    private func close(_ error: Error?)
    {
        guard(state != .Closed) else { return; }
        
        endpoint.close();
        state = .Closed;
        
        if let delegate = self.delegate {
            DispatchQueue.main.async() { delegate.portDidClose(self, reason: error); }
        }
    }
    
    private func initialized(with error: Error?)
    {
        if error == nil {
            state = .Open;
            endpoint.resumeIn();
        }
        else {
            state = .Closed;
            endpoint.close();
        }
    
        delegate?.portDidInitialize(self, with: error);
    }
    
    /**
     Receive handler.
     */
    func receive()
    {
        var count: Int;
        
        count = endpoint.receive(&buffer);
        while count > 0 {
            delegate?.port(self, didReceive: buffer.subdata(in: 0..<count));
            count = endpoint.receive(&buffer);
        }

        switch count {
        case Endpoint.Closed :
            close(nil);
            
        case Endpoint.Failed :
            close(nil);
            
        case Endpoint.WouldBlock :
            endpoint.resumeIn();

        default :
            close(nil);
        }
    }
    
    /**
     Send handler.
     */
    func send()
    {
        var count = Int();
        
        while !oqueue.isEmpty {
            
            count = endpoint.send(Data(oqueue));
            if count <= 0 {
                break;
            }
            
            oqueue.removeFirst(count);
        }
        
        if !oqueue.isEmpty {
            switch count {
            case Endpoint.WouldBlock :
                endpoint.resumeOut();
                
            default :
                shutdown(reason: nil);
            }
        }
    }

    // MARK: - EndpointDelegate
    
    func endpointDidConnect(_ endpoint: Endpoint, with error: Error?)
    {
        initialized(with: error);
    }
    
    func endpointIn(_ endpoint: Endpoint)
    {
        receive();
    }
    
    func endpointOut(_ endpoint: Endpoint)
    {
        send();
    }
    
}


// End of File
