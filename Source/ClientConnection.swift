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
 Backend
 */
public typealias Backend = DeviceBackendDelegate & ServiceBackendDelegate & ResourceBackendDelegate

/**
 Client connection.
 
 Extends Connection, providing access to a backend protocol handler required by
 client connections.
 */
public protocol ClientConnection: Connection {
    
    /**
     Backend protocol.
     
     Used to publish the backend protocol once the connection has been
     established.
     */
    var backend: Backend! { get }
    
}


// End of File
