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


/**
 Network port factory.
 */
public class NetPortFactory: PortFactory {
    
    // MARK: - Properties
    public let domain    : String
    public let address   : SockAddr
    public var priority  : Int    { return type.priority }
    public var reachable : Bool   { return true }
    public let type      : DeviceProtocol
    
    // MARK: - Initializers
    
    /**
     Initialize instance.
     
     - Parameters:
        - domain:  The port domain.
        - type:    The device protocol descriptor.
        - address: The server port address.
     */
    init(domain: String, type: DeviceProtocol, address: SockAddr)
    {
        self.domain  = domain
        self.type    = type
        self.address = address
    }
    
    // MARK: - Instantiation
    
    /**
     Instantiate client connection.
     
     Instantiates a new client connection representing the principal.
     
     - Parameters:
        - principal: The principal represented by the connection.
     
     - Returns:
        Returns a reference to the new connection if successful.  A return
        value of nil indicates failure.
     */
    public func instantiateConnection(to device: DeviceBackend, as principal: Principal?) -> ClientConnection?
    {
        var connection: ClientConnection?
        
        if let port = instantiatePort() {
            connection = type.clientFactory.instantiate(to: port, for: device, as: principal)
        }
        
        return connection
    }
    
    /**
     Instantiate client port.
     
     Instantiates a new client port.
     
     - Returns:
        Returns a reference to the new port if successful.  A return value of
        nil indicates that the transport protocol is unsupported.
     */
    private func instantiatePort() -> PortNet?
    {
        switch address.proto {
        case .tcp :
            return PortNetStream(address: address)
            
        case .udp :
            return nil
        }
    }
    
}


// End of File
