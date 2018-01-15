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
 Service
 */
public protocol Service: class {
    
    // MARK: - Properties
    
    /**
     The service owner.
     */
    weak var device: Device? { get }
    
    /**
     Uniquely identifies the service.
     */
    var identifier: UUID { get }
    
    /**
     Service name.  Service names are not necessarily unique.
     */
    var name: String { get }
    
    /**
     Collection of resources.
     */
    var resources: [Resource] { get }
    
    /**
     Service type.
     */
    var type: ServiceType { get }
    
    // MARK: - Observers
    
    /**
     Add observer.
     */
    func addObserver(_ observer: ServiceObserver)
    
    /**
     Remove observer.
     */
    func removeObserver(_ observer: ServiceObserver)
    
    // MARK: - Mutators
    
    /**
     Update service name.
     
     - Parameters:
        - name: The new service name.
        - completion: Completion handler.
     */
    func updateName(_ name: String, completionHandler completion: @escaping (Error?) -> Void)
    
}

public extension Service {

    var profile: ServiceProfile { return ServiceProfile(for: self) }

}


// End of File
