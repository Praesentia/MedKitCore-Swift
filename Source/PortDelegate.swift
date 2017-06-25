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
 Port Delegate
 
 The port delegate is utilized by a component higher in the protocol stack to
 perform higher-level processing of the protocol.
 */
public protocol PortDelegate: class {
    
    // MARK: - Lifecycle
    
    /**
     Port did close.
     
     - Parameters:
        - port: The port that has been closed.
        - error: Error code.
     */
    func portDidClose(_ port: Port, for reason: Error?)
    
    /**
     Port did initialize.
     
     This method is called when the port has finished being initialized.
     
     - Parameters:
        - port:  The port that has been initialized.
        - error: Nil if successful.  Otherwise, the error that prevented the
                 port from initializing properly.
     */
    func portDidInitialize(_ port: Port, with error: Error?)
    
    // MARK: - Input
    
    /**
     Port did receive data.
     
     - Parameters:
        - port: Caller
        - data: The data being received from the port.
     */
    func port(_ port: Port, didReceive data: Data)
    
}


// End of File
