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
 Connection protocol.
 
 Connection is used to manage a single communication session.
 */
public protocol Connection: class {
    
    // MARK: - Properties
    
    /**
     DataTap used for logging.
     */
    var dataTap: DataTap? { get set }
    
    /**
     Connection delegate.
     */
    weak var delegate : ConnectionDelegate? { get set }
    
    /**
     The port at the base of the protocol stack.
     */
    var port: Port { get }
    
    // MARK: - Lifecycle
    
    /**
     Shutdown connection.
     
     - Parameters:
        - reason: Nil indicates a normal shutdown.  Otherwise, an error
                  indicating the reason that led to the connection being closed.
     */
    func shutdown(for reason: Error?)
    
    /**
     Start protocol stack.
     
     Initiates the startup of the protocol stack.
     
     - Parameters:
        - completion: The completion handler.
     */
    func start(completionHandler completion: @escaping (Error?)->Void)
    
}


// End of File
