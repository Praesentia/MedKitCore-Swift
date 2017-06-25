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
 Port Monitor
 */
public protocol PortMonitor {
    
    // MARK: - Properties
    
    /**
     The number of open connections.
     */
    var count: Int { get }
    
    /**
     Monitor delegate.
     */
    weak var delegate: PortMonitorDelegate? { get set }
    
    /**
     True if the monitor is currently active, false otherwise.
     */
    var enabled: Bool { get }
    
    // MARK: - Lifecycle
    
    /**
     Shutdown monitor.
     
     - Parameters:
        - reason: The reason for initiating a shutdown.  A non-nil value
                  indicates the error that triggered the shutdown. A nil value
                  indicates the shutdown was issued during the normal course of
                  operation.
     */
    func shutdown(for reason: Error?)
    
    /**
     Start monitor.
     
     - Parameters:
        - completion: The completion handler.
     */
    func start(completionHandler completion: @escaping (Error?)->Void)

}


// End of File
