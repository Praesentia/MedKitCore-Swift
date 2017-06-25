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
 Network port.
 
 A base port for Internet connections.
 */
public class PortNet: Port {
    
    // MARK: - Properties
    public weak var delegate    : PortDelegate?
    public var      hostAddress : SockAddr? { return endpoint?.hostAddress }
    public var      peerAddress : SockAddr? { return endpoint?.peerAddress }
    
    // MARK: - Protected Properties
    var address  : SockAddr
    var endpoint : EndpointNet!
    
    // MARK: - Initializers
    
    init(address: SockAddr)
    {
        self.address = address
    }
    
    // MARK: - Lifecycle
    
    public func shutdown(for reason: Error?)
    {
    }
    
    public func start()
    {
    }
    
    // MARK: - Output
    
    public func send(_ data: Data)
    {
    }

    
}


// End of File
