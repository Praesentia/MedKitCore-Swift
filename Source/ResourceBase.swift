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
 Resource
 */
public class ResourceBase: Resource, ResourceBackend {
    
    // Resource
    public var      access               : Access         { return _access; }
    public var      cache                : ResourceCache? { return _cache; }
    public var      identifier           : UUID           { return _identifier; }
    public var      notifications        : Bool           { return _notifications; }
    public var      notificationEnabled  : Bool           { return _notificationEnabled; }
    public var      profile              : JSON           { return getProfile(); }
    public var      schema               : UUID           { return _schema; }
    public weak var service              : Service?       { return _service; }
    public var      type                 : UUID           { return _type; }
    
    // ResourceBackend
    public var serviceBackend  : ServiceBackend?        { return _service; }
    public var backend : ResourceBackendDelegate!;
    
    // MARK: - Shadowed
    private let _access              : Access;
    private var _cache               : ResourceCacheBase!;
    private var _identifier          : UUID;
    private var _notifications       : Bool = false;
    private var _notificationEnabled : Bool = false;
    private var _schema              : UUID;
    private var _service             : ServiceBase?;
    private var _type                : UUID;
    
    // MARK: - Private
    private var observers                  = ObserverManager<ResourceObserver>();
    private var notificationEnabledPending = false;
    
    public init(_ service: ServiceBase, from profile: JSON)
    {
        backend = service.getDefaultBackend();
        
        _service       = service;
        _access        = Access(string: profile[KeyAccess].string!)!;
        _identifier    = profile[KeyIdentifier].uuid!;
        _notifications = profile[KeyNotifications].bool!;
        _schema        = profile[KeySchema].uuid!;
        _type          = profile[KeyType].uuid!;
    }
    
    public func addObserver(_ observer: ResourceObserver, completionHandler completion: @escaping (Error?) -> Void)
    {
        let sync = Sync();
        
        if !observers.contains(observer) {
            observers.add(observer);
            
            if observers.count == 1 {
                sync.incr();
                backend.resourceEnableNotification(self) { cache, error in
                    if error == nil, let cache = cache {
                        self.notificationEnabled(cache: ResourceCacheBase(from: cache));
                    }
                    sync.decr(error);
                }
            }
        }
        else {
            debugPrint("Unbalanced add observer.");
        }
        
        sync.close(completionHandler: completion);
    }
    
    public func removeObserver(_ observer: ResourceObserver, completionHandler completion: @escaping (Error?) -> Void)
    {
        let sync = Sync();
        
        if observers.contains(observer) {
            observers.remove(observer);
            
            if observers.count == 0 {
                sync.incr();
                backend.resourceDisableNotification(self) { error in
                    if error == nil {
                        self.notificationDisabled();
                    }
                    sync.decr(error);
                }
            }
        }
        
        sync.close(completionHandler: completion);
    }
    
    /**
     Read value.
     
     - Parameters:
     - completion:
     */
    public func readValue(completionHandler completion: @escaping (ResourceCache?, Error?) -> Void)
    {
        if let cache = self.cache {
            DispatchQueue.main.async { completion(cache, nil); }
        }
        else {
            backend.resourceReadValue(self, completionHandler: completion);
        }
    }
    
    public func writeValue(_ value: JSON?, completionHandler completion: @escaping (ResourceCache?, Error?) -> Void)
    {
        backend.resourceWriteValue(self, value, completionHandler: completion);
    }
    
    /**
     Get profile.
     */
    private func getProfile() -> JSON
    {
        let profile = JSON();
        
        profile[KeyAccess]        = access.string;
        profile[KeyIdentifier]    = identifier;
        profile[KeyNotifications] = notifications;
        profile[KeySchema]        = schema;
        profile[KeyType]          = type;
        
        return profile;
    }
    
    private func notificationEnabled(cache: ResourceCacheBase)
    {
        _notificationEnabled = true;
        _cache               = cache;
    }
    
    private func notificationDisabled()
    {
        _notificationEnabled = false;
        _cache               = nil;
    }
    
    // MARK: - ResourceBackend
    
    /**
     Get default backend.
     */
    public func getDefaultBackend() -> Backend
    {
        return _service!.getDefaultBackend();
    }
    
    /**
     Update resource.
     
     - Parameters:
     - changes:
     - time:
     */
    public func update(changes: JSON, at time: TimeInterval)
    {
        if notificationEnabled {
            _cache.update(changes: changes, at: time);
            observers.withEach { observer in
                observer.resourceDidUpdate(self, value: _cache.value, at: _cache.timeModified);
            }
        }
    }
    
    /**
     Update resource.
     
     - Parameters:
     - value:
     - time:
     */
    public func update(value: JSON?, at time: TimeInterval)
    {
        if notificationEnabled {
            _cache = ResourceCacheBase(value: value, at: time);
            observers.withEach { observer in
                observer.resourceDidUpdate(self, value: _cache.value, at: _cache.timeModified);
            }
        }
    }
    
    /**
     Update resource.
     
     - Parameters:
     - cache:
     */
    public func update(from cache: ResourceCache)
    {
        if notificationEnabled {
            _cache = ResourceCacheBase(from: cache);
            observers.withEach { observer in
                observer.resourceDidUpdate(self, value: _cache.value, at: _cache.timeModified);
            }
        }
    }
    
}


// End of File
