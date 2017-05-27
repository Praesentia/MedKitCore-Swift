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
 Device base.
 
 Base class for device instances.
 */
public class DeviceBase: DeviceFrontend, DeviceBackend {
    
    // MARK: - Properties
    public private(set) var acl            = ACL();
    public private(set) var identifier     : UUID;
    public var              isOpen         : Bool      { return backend?.isOpen ?? false; }
    public private(set) var name           : String;
    public private(set) var manufacturer   : String;
    public private(set) var model          : String;
    public weak var         parent         : Device?   { return _parent; }
    public var              profile        : JSON      { return getProfile(); }
    public var              reachable      : Bool      { return true; }
    public private(set) var serialNumber   : String;
    public private(set) var type           : UUID;
    public var              bridgedDevices : [Device]  { return _bridgedDevices; }
    public var              services       : [Service] { return _services; }
    
    // DeviceBackend
    public var       backend               : DeviceBackendDelegate!;
    public var       defaultBackend        : Backend                 { return BackendDefault.main; }
    public var       bridgedDeviceBackends : [DeviceBackend]         { return _bridgedDevices; }
    public var       serviceBackends       : [ServiceBackend]        { return _services; }
    
    // MARK: - Shadowed
    private weak var _parent         : DeviceBase?;
    private var      _bridgedDevices = [DeviceBase]();
    private var      _services       = [ServiceBase]();
    
    // MARK: - Protected
    var observers = ObserverManager<DeviceObserver>();
    
    // MARK: - Initializers
    
    /**
     Initialize instance from device information.
     */
    public init(from deviceInfo: DeviceInfo)
    {
        identifier   = deviceInfo.identifier;
        manufacturer = deviceInfo.manufacturer;
        model        = deviceInfo.model;
        name         = deviceInfo.name;
        serialNumber = deviceInfo.serialNumber;
        type         = deviceInfo.type;
        
        backend = BackendDefault.main;
    }
    
    /**
     Initialize instance from profile.
     */
    public init(_ parent: DeviceBase?, from profile: JSON)
    {
        backend = (parent != nil) ? parent!.defaultBackend : BackendDefault.main;
        
        _parent      = parent;
        identifier   = profile[KeyIdentifier].uuid!;
        manufacturer = profile[KeyManufacturer].string!;
        model        = profile[KeyModel].string!;
        name         = profile[KeyName].string!;
        serialNumber = profile[KeySerialNumber].string!;
        type         = profile[KeyType].uuid!;
        
        if let bridgedDevices = profile[KeyBridgedDevices].array {
            for profile in bridgedDevices {
                _bridgedDevices.append(DeviceBase(self, from: profile));
            }
        }
        
        if let services = profile[KeyServices].array {
            for profile in services {
                _services.append(ServiceBase(self, from: profile));
            }
        }
    }
    
    // MARK: - Observer Interface
    
    /**
     Add device observer.
     */
    public func addObserver(_ observer: DeviceObserver)
    {
        observers.add(observer);
    }
    
    /**
     Remove device observer.
     */
    public func removeObserver(_ observer: DeviceObserver)
    {
        observers.remove(observer);
    }
    
    // MARK: - Connectivity
    
    /**
     Close connection to device.
     */
    func close(for reason: Error?)
    {
    }
    
    /**
     Close connection to device, with completion handler.
     */
    public func close(completionHandler completion: @escaping (Error?) -> Void)
    {
        DispatchQueue.main.async {
            self.disconnected(for: nil); // TODO
            completion(nil);
        }
    }
    
    /**
     Open device.
     */
    public func open(completionHandler completion: @escaping (Error?) -> Void)
    {
        DispatchQueue.main.async {
            self.connected(); // TODO
            completion(nil);
        }
    }
    
    public func connected()
    {
        observers.withEach { $0.deviceOpened(self); }
        
        for service in _services {
            service.connected();
        }
    
        for bridgedDevice in _bridgedDevices {
            bridgedDevice.connected();
        }
    }
    
    public func disconnected(for reason: Error?)
    {
        for bridgedDevice in _bridgedDevices {
            bridgedDevice.disconnected(for: reason);
        }
        
        for service in _services {
            service.disconnected();
        }
        
        observers.withEach { $0.deviceDidClose(self, for: reason); }
    }
    
    // MARK: - Mutators
    
    /**
     Update name.
     */
    public func updateName(_ name: String, completionHandler completion: @escaping (Error?) -> Void)
    {
        backend.device(self, updateName: name, completionHandler: completion);
    }
    
    
    // MARK: - Profile
    
    /**
     Get device profile.
     */
    private func getProfile() -> JSON
    {
        let profile = JSON();
        
        profile[KeyIdentifier]   = JSON(identifier);
        profile[KeyName]         = JSON(name);
        profile[KeyManufacturer] = JSON(manufacturer);
        profile[KeyModel]        = JSON(model);
        profile[KeySerialNumber] = JSON(serialNumber);
        profile[KeyType]         = JSON(type);
        profile[KeyServices]     = services.map { $0.profile };
        
        return profile;
    }
    
    // MARK: - DeviceBackend protocol
    
    /**
     Get bridged device with identifier.
     */
    public func getBridgedDevice(withIdentifier identifier: UUID) -> DeviceBase?
    {
        for bridgedDevice in _bridgedDevices {
            if bridgedDevice.identifier == identifier {
                return bridgedDevice;
            }
        }
        
        return nil;
    }
    
    /**
     Get service with identifier.
     */
    public func getService(withIdentifier identifier: UUID) -> ServiceBackend?
    {
        for service in _services {
            if service.identifier == identifier {
                return service;
            }
        }
        
        return nil;
    }
    
    /**
     Add bridged device.
     */
    public func addBridgedDevice(from profile: JSON, notify: Bool) -> DeviceBackend
    {
        let bridgedDevice = DeviceBase(self, from: profile);
        
        _bridgedDevices.append(bridgedDevice);
        
        if notify {
            observers.withEach { $0.device(self, didAdd: bridgedDevice); }
        }
        
        return bridgedDevice;
    }
    
    /**
     Remove bridged device.
     */
    public func removeBridgedDevice(_ bridgedDevice: DeviceBackend, notify: Bool)
    {
        if let index = (_bridgedDevices.index { $0 === bridgedDevice; }) {
            let device = _bridgedDevices[index];
            
            _bridgedDevices.remove(at: index);
            
            if notify {
                observers.withEach { $0.device(self, didRemove: device); }
            }
        }
    }
    
    /**
     Add service.
     */
    public func addService(_ service: ServiceBase, notify: Bool)
    {
        _services.append(service);
        
        if notify {
            observers.withEach { $0.device(self, didAdd: service); }
        }
    }
    
    /**
     Add service.
     */
    public func addService(from profile: JSON, notify: Bool) -> ServiceBackend
    {
        let service = ServiceBase(self, from: profile);
        
        _services.append(service);
        
        if notify {
            observers.withEach { $0.device(self, didAdd: service); }
        }
        
        return service;
    }
    
    /**
     Remove service.
     */
    public func removeService(withIdentifier identifier: UUID, notify: Bool)
    {
        if let index = (_services.index { $0.identifier == identifier; }) {
            let service = _services[index];
            
            _services.remove(at: index);
            
            if notify {
                observers.withEach { $0.device(self, didRemove: service); }
            }
        }
    }
    
    // MARK: - Mutators
    
    /**
     Update from profile.
     */
    public func update(from profile: JSON)
    {
        // TODO: these shouldn't change
        identifier   = profile[KeyIdentifier].uuid!;
        manufacturer = profile[KeyManufacturer].string!;
        model        = profile[KeyModel].string!;
        serialNumber = profile[KeySerialNumber].string!;
        type         = profile[KeyType].uuid!;
        
        // update name
        if let name = profile[KeyName].string {
            if self.name != name {
                self.name = name;
                observers.withEach { $0.deviceDidUpdateName(self); }
            }
        }
        
        // update bridged devices
        if let bridgedDevices = profile[KeyBridgedDevices].array {
            for profile in bridgedDevices {
                if getBridgedDevice(withIdentifier: profile[KeyIdentifier].uuid!) == nil {
                    _ = addBridgedDevice(from: profile, notify: true);
                }
            }
        }
        
        // update services
        if let services = profile[KeyServices].array {
            for profile in services {
                if getService(withIdentifier: profile[KeyIdentifier].uuid!) == nil {
                    _ = addService(from: profile, notify: true);
                }
            }
        }
    }
    
    /**
     Update name.
     */
    public func updateName(_ name: String, notify: Bool)
    {
        self.name = name;
        
        if notify {
            observers.withEach { $0.deviceDidUpdateName(self); }
        }
    }
    
}


// End of File
