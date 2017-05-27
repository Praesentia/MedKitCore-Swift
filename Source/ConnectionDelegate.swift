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
 Connection delegate.
 */
public protocol ConnectionDelegate: class {
    
    // MARK: - Lifecycle
    
    /**
     Connection did close.
     
     - Parameters:
        - connection: The connection that was closed.
        - reason:     Nil indicates a normal shutdown.  Otherwise, the error
                      responsible for the connection being closed.
     
     - Remarks:
        This method is dispatched asynchronously in order to insure that it is
        delivered last.
     */
    func connectionDidClose(_ connection: Connection, for reason: Error?);
    
}


// End of File
