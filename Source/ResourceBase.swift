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
 Resource
 */
public class ResourceBase: Resource, ResourceBackend {

    // MARK: - Properties
    public let              access              : Access
    public private(set) var identifier          : UUID
    public private(set) var notifications       : Bool = false
    public private(set) var notificationEnabled : Bool = false
    public private(set) var proto               : ResourceProtocolType
    public weak var         service             : Service?        { return _service }
    public private(set) var subject             : ResourceSubject
    
    // ResourceBackend
    public var defaultBackend : Backend                   { return serviceBackend.defaultBackend }
    public var serviceBackend : ServiceBackend!           { return _service }
    public var backend        : ResourceBackendDelegate!
    
    // MARK: - Shadowed
    private var _service : ServiceBase?
    
    // MARK: - Private
    private var observers = [ResourceObserver]()
    
    // MARK: - Initializers
    
    public init(_ service: ServiceBase, from profile: ResourceProfile)
    {
        backend = service.defaultBackend

        _service      = service
        access        = profile.access
        identifier    = profile.identifier
        notifications = profile.notifications
        proto         = profile.proto
        subject       = profile.subject
    }
    
    // MARK: - Observer Interface
    
    public func addObserver(_ observer: ResourceObserver, completionHandler completion: @escaping (Error?) -> Void)
    {
        let sync = Sync()
        
        if observers.index(where: { $0 === observer }) == nil {
            observers.append(observer)
            
            if observers.count == 1 && backend.isOpen {
                sync.incr()
                backend.resourceEnableNotification(self, enable: true) { error in
                    if error == nil {
                        self.notificationEnabled = true
                    }
                    sync.decr(error)
                }
            }
        }
        else {
            sync.fail(MedKitError.failed) // TODO: already enabled
        }
        
        sync.close(completionHandler: completion)
    }
    
    public func removeObserver(_ observer: ResourceObserver, completionHandler completion: @escaping (Error?) -> Void)
    {
        let sync = Sync()
        
        if let index = observers.index(where: { $0 === observer }) {
            observers.remove(at: index)
            
            if observers.count == 0 {
                sync.incr()
                backend.resourceEnableNotification(self, enable: false) { error in
                    if error == nil {
                        self.notificationEnabled = false
                    }
                    sync.decr(error)
                }
            }
        }
        else {
            sync.fail(MedKitError.failed) // TODO: already disabled
        }
        
        sync.close(completionHandler: completion)
    }
    
    // MARK: -
    
    func connected()
    {
        if observers.count > 0 {
            backend.resourceEnableNotification(self, enable: true) { error in
                if error == nil {
                    // TODO self.notificationEnabled(cache: ResourceCacheBase(from: cache))
                }
            }
        }
    }
    
    func disconnected()
    {
        if observers.count > 0 && notificationEnabled {
            notificationEnabled = false
        }
    }
    
    // MARK: - Protocol Interface

    /**
     Call
     
     - Parameters:
        - completion:
     */
    public func call(message: AnyCodable, completionHandler completion: @escaping (AnyCodable?, Error?) -> Void)
    {
        backend.resource(self, didCallWith: message, completionHandler: completion)
    }
    
    // MARK: - ResourceBackend

    /**
     Decode asynchronous call.
     */
    public func notify(_ notification: AnyCodable)
    {
        observers.forEach { $0.resource(self, didNotifyWith: notification) }
    }
    
}


// End of File
