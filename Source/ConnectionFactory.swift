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
 Connection factory protocol.
 */
public protocol ClientConnectionFactory {
    
    var priority: Int { get } //: Protocol priority.
    
    /**
     Create connection.
     
     - Parameters:
        - port: The server port.
        - principal: The principal for the client.
     */
    func instantiate(port: Port, as principal: Principal?) -> ClientConnection;
    
}

/**
 Connection factory protocol.
 */
public protocol ServerConnectionFactory {

    var protocolType: String { get } //: Identifies the protocol implemented by the factory.
    
    /**
     Create connection.
     
     - Parameters:
        - port: The client port.
        - device: The device for which the connection is being made.
        - principal: The principal for the device.
     */
    func instantiate(from port: Port, to device: DeviceFrontend, as principal: Principal) -> Connection;
    
}

/**
 Connection factory.
 */
public class ClientConnectionFactoryTemplate<T: ClientConnection>: ClientConnectionFactory {
    
    public let priority: Int;
    
    public init(priority: Int)
    {
        self.priority = priority;
    }
    
    public func instantiate(port: Port, as principal: Principal?) -> ClientConnection
    {
        return T(to: port, as: principal);
    }
    
}

/**
 Connection factory.
 */
public class ServerConnectionFactoryTemplate<T: ServerConnection>: ServerConnectionFactory {

    public let protocolType: String;
    
    public init(protocolType: String)
    {
        self.protocolType = protocolType;
    }
    
    public func instantiate(from port: Port, to device: DeviceFrontend, as principal: Principal) -> Connection
    {
        return T(from: port, to: device, as: principal);
    }
    
}


// End of File
