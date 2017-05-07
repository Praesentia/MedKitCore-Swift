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
 Client connection.
 
 A base class for client connections.
 */
open class ClientConnection: Connection {
    
    /**
     Device backend.
     */
    open var backend: Backend { fatalError("Not implemented"); }
    
    /**
     Initialize instance.
     
     - Parameters:
        - port:      The server port.
        - principal: The principal for the client.
     */
    required public init(to port: Port, as principal: Principal?)
    {
        super.init(port: port);
    }
    
}


// End of File
