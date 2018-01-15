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
 ProtocolStack protocol.
 
 This protocol is used to implement components that cap a protocol stack, and
 so require a slightly different interface from the one provided by the Port
 protocol.
 */
public protocol ProtocolStack: class {

    // MARK: - Properties
    
    /**
     ProtocolStack delegate.
     */
    weak var delegate: ProtocolStackDelegate? { get set }
    
    // MARK: - Lifecycle
    
    /**
     Shutdown protocol stack.
     
     - Parameters:
        - reason: Nil indicates a normal shutdown.  Otherwise, an error
                  indicating the reason that led to the stack being closed.
     */
    func shutdown(for reason: Error?)
    
    /**
     Start protocol stack.
     
     - Parameters:
        - completion: The completion handler.
     */
    func start(completionHandler completion: @escaping (Error?)->Void)
    
}


// End of File
