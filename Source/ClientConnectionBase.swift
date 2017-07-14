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
 Base class for client connections.
 */
open class ClientConnectionBase: ConnectionBase, ClientConnection {
    
    // MARK: - Properties
    open var backend: Backend! { return _backend }
    
    // MARK: - Shadowed
    public var _backend: Backend?
    
    // MARK: - Initializers
    
    /**
     Initialize instance.
     
     - Parameters:
        - port:      A port used to establish the connection to the server.
        - principal: The principal used to identify the client to the server.
     */
    required public init(to port: Port, for device: DeviceBackend, as principal: Principal?)
    {
        super.init(port: port)
    }
    
}


// End of File
