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
 Service base.
 
 Base class for service instances.
 */
public class ServiceBase: Service, ServiceBackend {
    
    // Service
    public weak var device     : Device?     { return _device }
    public var      identifier : UUID        { return _identifier; }
    public var      name       : String      { return _name; }
    public var      profile    : JSON        { return getProfile(); }
    public var      resources  : [Resource]  { return _resources; }
    public var      type       : UUID        { return _type; }
    
    // ServiceBackend
    public var deviceBackend    : DeviceBackend?           { return _device; }
    public var backend  : ServiceBackendDelegate!;
    public var resourceBackends : [ResourceBackend]        { return _resources; }
    
    // MARK: - Shadowed
    private var _device      : DeviceBase?;
    private let _identifier  : UUID;
    private var _name        : String;
    private let _type        : UUID;
    private var _resources   = [ResourceBase]();
    
    // MARK: - Private
    private var  observers  = ObserverManager<ServiceObserver>();
    
    /**
     Initialize instance from profile.
     */
    public init(_ device: DeviceBase, from profile: JSON)
    {
        backend = device.defaultBackend;
        
        _device     = device;
        _identifier = profile[KeyIdentifier].uuid!;
        _name       = profile[KeyName].string!;
        _type       = profile[KeyType].uuid!;
        
        if let resources = profile[KeyResources].array {
            for profile in resources {
                _resources.append(ResourceBase(self, from: profile));
            }
        }
    }
    
    public func addObserver(_ observer: ServiceObserver)
    {
        observers.add(observer);
    }
    
    public func removeObserver(_ observer: ServiceObserver)
    {
        observers.remove(observer);
    }
    
    /**
     Update service name.
     
     - Parameters:
     - name:
     - completion:
     */
    public func updateName(_ name: String, completionHandler completion: @escaping (Error?) -> Void)
    {
        backend.service(self, updateName: name, completionHandler: completion);
    }
    
    /**
     Get profile.
     */
    private func getProfile() -> JSON
    {
        let profile = JSON();
        
        profile[KeyIdentifier] = JSON(identifier);
        profile[KeyName]       = JSON(name);
        profile[KeyType]       = JSON(type);
        profile[KeyResources]  = resources.map { $0.profile }
        
        return profile;
    }
    
    // MARK: - ServiceBackend
    
    /**
     Get default backend.
     */
    public func getDefaultBackend() -> Backend
    {
        return _device!.defaultBackend;
    }
    
    public func getResource(withIdentifier identifier: UUID) -> ResourceBackend?
    {
        for resource in _resources {
            if resource.identifier == identifier {
                return resource;
            }
        }
        
        return nil;
    }
    
    public func addResource(_ resource: ResourceBase, notify : Bool)
    {
        _resources.append(resource);
        
        if notify {
            observers.withEach { delegate in
                delegate.service(self, didAdd: resource);
            }
        }
    }
    
    public func removeResource(withIdentifier identifier: UUID, notify : Bool)
    {
        if let index = (_resources.index { $0.identifier == identifier; }) {
            let resource = _resources[index];
            
            _resources.remove(at: index);
            
            if notify {
                observers.withEach { delegate in
                    delegate.service(self, didRemove: resource);
                }
            }
        }
    }
    
    /**
     Update name.
     */
    public func updateName(_ name: String, notify: Bool)
    {
        _name = name;
        
        if notify {
            observers.withEach { delegate in
                delegate.serviceDidUpdateName(self);
            }
        }
    }
    
}


// End of File
