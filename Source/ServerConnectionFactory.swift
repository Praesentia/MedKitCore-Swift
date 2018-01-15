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
 ServerConnectionFactory protocol.
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
    func instantiate(from port: Port, to device: DeviceFrontend, using principalManager: PrincipalManager) -> ServerConnectionBase
    
}

/**
 ServerConnectionFactory template.
 */
public class ServerConnectionFactoryTemplate<T: ServerConnectionBase>: ServerConnectionFactory {

    public let protocolType: String
    
    public init(protocolType: String)
    {
        self.protocolType = protocolType
    }
    
    public func instantiate(from port: Port, to device: DeviceFrontend, using principalManager: PrincipalManager) -> ServerConnectionBase
    {
        return T(from: port, to: device, using: principalManager)
    }
    
}


// End of File
