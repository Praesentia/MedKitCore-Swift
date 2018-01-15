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
 Network listener.
 
 A base class for network listeners.
 */
public class PortMonitorNetListener: PortMonitor, ConnectionDelegate, EndpointDelegate {
    
    // MARK: - Internal Types
    enum State {
        case closed
        case open
        case shutdown
    }
    
    // MARK: - Properties
    public var      connections = [Connection]()
    public var      count       : Int { return connections.count }
    public weak var delegate    : PortMonitorDelegate?
    public var      enabled     : Bool { return state == .open }
    public let      address     : SockAddr //: Host address used to listen for incoming connections.
    public var      hostAddress : SockAddr? { return endpoint?.hostAddress }

    // MARK: - Protected Properties
    let Backlog           : Int32 = 10         //: Backlog
    var serviceResponder  : ServiceResponder?  //: Used to publish the service.
    var state             : State = .closed
    var endpoint          : EndpointNet!       //: Listener
    
    // MARK: - Initializers
    
    /**
     Initialize instance.
     */
    public init(address: SockAddr)
    {
        self.address = address
    }
    
    // MARK: - Lifecycle
    
    /**
     Shutdown monitor.
     */
    public func shutdown(for reason: Error?)
    {
        guard(state == .open) else { return }
        
        state = .shutdown
        
        serviceResponder?.retract()
        endpoint.close()
        endpoint = nil
        
        if !connections.isEmpty {
            for connection in connections {
                connection.shutdown(for: reason)
            }
        }
        else {
            closed()
        }
    }
    
    /**
     Start monitor.
     */
    public func start(completionHandler completion: @escaping (Error?)->Void)
    {
        let sync = Sync(MedKitError.failed)

        if state == .closed {
            sync.incr()
            sync.fail(nil)
            
            endpoint          = EndpointNet()
            endpoint.delegate = self
            
            if endpoint.listen(address: address, backlog: Backlog) {
                serviceResponder = publishService(using: endpoint.hostAddress!)
                endpoint.resumeIn()
                state = .open
                sync.decr(nil)
            }
            else {
                sync.decr(MedKitError.failed)
            }
        }
        
        sync.close() { error in completion(error) }
    }
    
    /**
     Publish service.
     
     - Parameters:
        - address:
     */
    func publishService(using address: SockAddr) -> ServiceResponder?
    {
        return nil
    }
    
    // MARK: - Connection Management
    
    /**
     Create connection.
     */
    func instantiateConnection(from endpoint: EndpointNet) -> Connection?
    {
        return nil
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
                if let connection = instantiateConnection(from: client) {
                    connection.delegate = self
                    connections.append(connection)
                    delegate?.portMonitor(self, didAdd: connection)
                }
            }
        }
        
        endpoint.resumeIn()
    }
    
    /**
     Closed.
     */
    private func closed()
    {
        state = .closed
        if let delegate = self.delegate {
            DispatchQueue.main.async { delegate.portMonitorDidClose(self, for: nil) }
        }
    }
    
    // MARK: - ConnectionDelegate
    
    /**
     Connection did close.
     
     - Parameters:
        - connection:
        - error:
     */
    public func connectionDidClose(_ connection: Connection, for reason: Error?)
    {
        if let index = (connections.index { $0 === connection }) {
            
            connections.remove(at: index)
            delegate?.portMonitor(self, didRemove: connection) // TODO
            
            if state == .shutdown && connections.isEmpty {
                closed()
            }
        }
    }
    
    // MARK: - EndpointDelegate
    
    /**
     Endpoint input.
     */
    func endpointIn(_ endpoint: Endpoint)
    {
        accept()
    }
    
}


// End of File
