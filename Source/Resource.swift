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
 Resource protocol.
 
 Resources are essentually a form of microservice.
 
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
     Identifies the resource protocol.
     */
    var proto: ResourceProtocolType { get }
    
    /**
     The owning service.
     */
    weak var service: Service? { get }
    
    /**
     Identifies the subject of the resource.
     */
    var subject: ResourceSubject { get }
    
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

    func call(message: AnyCodable, completionHandler completion: @escaping (AnyCodable?, Error?) -> Void)
    
}

public extension Resource {

    var profile: ResourceProfile { return ResourceProfile(for: self) }

}


// End of File
