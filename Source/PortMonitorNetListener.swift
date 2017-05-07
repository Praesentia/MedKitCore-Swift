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
 Network listener.
 
 A base class for various types of network listeners.
 */
public class PortMonitorNetListener: PortMonitor, EndpointDelegate, ConnectionDelegate {
    
    // public
    override public var count       : Int { return connections.count; }
    public var          connections = [Connection]();
    
    // protected
    let Backlog           : Int32 = 10;         //: Backlog
    let address           : SockAddr;           //: Host address used to listen for incoming connections.
    var serviceResponder  : ServiceResponder?;  //: Use to publish the service.

    var endpoint          : EndpointNet!;       //: Listener
    
    /**
     Initialize instance.
     */
    public init(address: SockAddr)
    {
        self.address = address;
        super.init();
    }
    
    /**
     Start monitor.
     */
    override public func start()
    {
        guard(state == .Closed) else { return; }
        
        endpoint          = EndpointNet();
        endpoint.delegate = self;
        
        if endpoint.listen(address: address, backlog: Backlog) {
            serviceResponder = publishService(using: endpoint.hostAddress!);
            endpoint.resumeIn();
            _state = .Open;
        }
        else {
            // TODO
        }
    }
    
    /**
     Shutdown monitor.
     */
    override public func shutdown(reason: Error?)
    {
        guard(state == .Open) else { return; }
        
        _state = .Shutdown;
        
        serviceResponder?.retract();
        endpoint.close();
        endpoint = nil;
        
        if !connections.isEmpty {
            for connection in connections {
                connection.shutdown(reason: reason);
            }
        }
        else {
            closed();
        }
    }
    
    /**
     Create connection.
     */
    func instantiateConnection(to endpoint: EndpointNet) -> Connection?
    {
        return nil;
    }
    
    /**
     Publish service.
     
     - Parameters:
     - address:
     */
    func publishService(using address: SockAddr) -> ServiceResponder?
    {
        return nil;
    }
    
    /**
     Accept connection request.
     
     This method is used to handle acceptance of the next connection on the
     endpoint.
     */
    private func accept()
    {
        if let client = endpoint.accept() {
            if delegate?.portMonitor(self, shouldAccept: client.peerAddress!) ?? true {
                if let connection = instantiateConnection(to: client) {
                    connection.delegate = self;
                    connections.append(connection);
                    delegate?.portMonitor(self, didAdd: connection);
                }
            }
        }
        
        endpoint.resumeIn();
    }
    
    /**
     Closed.
     */
    private func closed()
    {
        _state = .Closed;
        if let delegate = self.delegate {
            DispatchQueue.main.async() { delegate.portMonitorDidClose(self, reason: nil); }
        }
    }
    
    // MARK: - EndpointDelegate
    
    /**
     Endpoint input.
     */
    func endpointIn(_ endpoint: Endpoint)
    {
        accept();
    }
    
    // MARK: - ConnectionDelegate
    
    /**
     Connection did close.
     
     - Parameters:
        - connection:
        - error:
     */
    public func connectionDidClose(_ connection: Connection, reason: Error?)
    {
        if let index = (connections.index { $0 === connection; }) {
            
            connections.remove(at: index);
            delegate?.portMonitor(self, didRemove: connection); // TODO
            
            if state == .Shutdown && connections.isEmpty {
                closed();
            }
        }
    }
    
}


// End of File
