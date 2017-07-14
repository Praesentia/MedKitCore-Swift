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
 Secure port policy delegate.
 
 Placeholder.∫
 */
public protocol PortSecurePolicy: class {
    
    /**
     Should authenticate peer.
     */
    func portShouldAuthenticatePeer(_ port: PortSecure) -> Bool
    
    /**
     Should accept peer.
     
     - Parameters:
        - port:
        - peer:
     
     - Precondition: peer.trusted
     */
    func port(_ port: PortSecure, shouldAccept peer: Principal) -> Bool
    
}


// End of File
