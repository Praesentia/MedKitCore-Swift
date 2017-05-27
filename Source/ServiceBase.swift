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
    
    // MARK: - Properties
    public weak var              device     : Device?     { return _device }
    public private(set) var      identifier : UUID;
    public private(set) var      name       : String;
    public var                   profile    : JSON        { return getProfile(); }
    public var                   resources  : [Resource]  { return _resources; }
    public private(set) var      type       : UUID;
    
    // MARK: - Properties - ServiceBackend
    public var deviceBackend    : DeviceBackend!           { return _device; }
    public var defaultBackend   : Backend                  { return deviceBackend.defaultBackend; }
    public var backend          : ServiceBackendDelegate!;
    public var resourceBackends : [ResourceBackend]        { return _resources; }
    
    // MARK: - Shadowed
    private var _device    : DeviceBase?;
    private var _resources = [ResourceBase]();
    
    // MARK: - Private
    private var  observers  = ObserverManager<ServiceObserver>();
    
    // MARK: - Initializers
    
    /**
     Initialize instance from profile.
     */
    public init(_ device: DeviceBase, from profile: JSON)
    {
        backend = device.defaultBackend;
        
        _device    = device;
        identifier = profile[KeyIdentifier].uuid!;
        name       = profile[KeyName].string!;
        type       = profile[KeyType].uuid!;
        
        if let resources = profile[KeyResources].array {
            for profile in resources {
                _resources.append(ResourceBase(self, from: profile));
            }
        }
    }
    
    // MARK: - Observer Interface
    
    public func addObserver(_ observer: ServiceObserver)
    {
        observers.add(observer);
    }
    
    public func removeObserver(_ observer: ServiceObserver)
    {
        observers.remove(observer);
    }
    
    // MARK: - Mutators
    
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
    
    // MARK: - Profile
    
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
    
    func connected()
    {
        for resource in _resources {
            resource.connected();
        }
    }
    
    func disconnected()
    {
        for resource in _resources {
            resource.disconnected();
        }
    }
    
    // MARK: - ServiceBackend
    
    /**
     Update name.
     */
    public func updateName(_ name: String, notify: Bool)
    {
        self.name = name;
        
        if notify {
            observers.withEach { $0.serviceDidUpdateName(self); }
        }
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
            observers.withEach { $0.service(self, didAdd: resource); }
        }
    }
    
    public func removeResource(withIdentifier identifier: UUID, notify : Bool)
    {
        if let index = (_resources.index { $0.identifier == identifier; }) {
            let resource = _resources[index];
            
            _resources.remove(at: index);
            
            if notify {
                observers.withEach { $0.service(self, didRemove: resource); }
            }
        }
    }
    
}


// End of File
