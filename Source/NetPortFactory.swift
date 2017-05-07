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
 Network port factory.
 */
public class NetPortFactory: PortFactory {
    
    // public
    public let domain    : String
    public let address   : SockAddr;
    public var priority  : Int    { return type.priority; }
    public var reachable : Bool   { return true; }
    public let type      : DeviceProtocol;
    
    /**
     Initialize instance.
     
     - Parameters:
        - domain:  The port domain.
        - address: The server port address.
        - type:    The device protocol descriptor.
     */
    init(domain: String, type: DeviceProtocol, address: SockAddr)
    {
        self.domain  = domain;
        self.type    = type;
        self.address = address;
    }
    
    /**
     Create connection to port.
     
     - Parameters:
        - principal: The pricipal for which the connection will be established.
     */
    public func instantiateConnection(as principal: Principal?) -> ClientConnection?
    {
        return type.clientFactory.instantiate(port: PortNetTCP(address: address), as: principal);
    }
    
}


// End of File
