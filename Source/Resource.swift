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
 Resource protocol.
 
 Resources are essentually a form of microservice, with the current design
 managing a single JSON value.
 
 # Notifications
 Resources may support notifications, which are automatically enabled whenever
 an observer is registered with an instance.
 */
public protocol Resource: class {
    
    // MARK: - Properties
    
    /**
     Accessability of the resource value.
     */
    var access: Access { get }
    
    /**
     A cached copy of the resource value.   The cache is normally nil, except
     when notifications are enabled.  With notifications enabled, the cache is
     automatically populated and kept up to date.
     */
    var cache: ResourceCache? { get }
    
    /**
     Uniquely identfies the resource.
     */
    var identifier: UUID { get }
    
    /**
     True if notification are supported by the resource, otherwise false.
     */
    var notifications: Bool { get }
    
    /**
     True if notifications are current enabled in the client, otherwise false.
     */
    var notificationEnabled: Bool { get }

    /**
     Provides a JSON representation of the resource metadata, i.e. the resource
     value is not included.
     */
    var profile: JSON { get }
    
    /**
     Identifies the schema of the resource value.
     */
    var schema: UUID { get }
    
    /**
     The owning service.
     */
    weak var service: Service? { get }
    
    /**
     Identifies the type of resource.
     */
    var type: ResourceType { get }
    
    // MARK: - Observer Interface
    
    /**
     Add observer.
     
     If supported, notifications are automatically enabled when the first
     observer is added.
     
     - Parameters:
        - observer: The observer to be added.
     */
    func addObserver(_ observer: ResourceObserver, completionHandler completion: @escaping (Error?) -> Void)

    /**
     Remove observer.
     
     If supported, notifications are automatically disabled when the last
     observer is removed.
     
     - Parameters:
        - observer: The observer to be removed.
     */
    func removeObserver(_ observer: ResourceObserver, completionHandler completion: @escaping (Error?) -> Void)
    
    // MARK: - Value Management
    
    /**
     Read value.
     
     Reads the current resource value, which is subsequently returned to the
     completion handler.
     
     If notifications are enabled, the method simply returns the current cached
     value.
     
     - Parameters:
        - completion: A completion handler.
            - cache:
            - error:
     */
    func readValue(completionHandler completion: @escaping (ResourceCache?, Error?) -> Void)
    
    /**
     Writes value.
     
     - Parameters:
        - value: The value to be written.
        - completion: A completion handler.
            - cache:
            - error:
     */
    func writeValue(_ value: JSON?, completionHandler completion: @escaping (ResourceCache?, Error?) -> Void)
    
}


// End of File
