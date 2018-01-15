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
import SecurityKit


/**
 Device base.
 
 Base class for device instances.
 */
public class DeviceBase: DeviceFrontend, DeviceBackend {

    // MARK: - Properties
    public private(set) var acl            = ACL()
    public var              identifier     : UUID           { return identity.identifier }
    public let              identity       : DeviceIdentity
    public var              isOpen         : Bool           { return backend?.isOpen ?? false }
    public private(set) var name           : String
    public var              manufacturer   : String         { return identity.manufacturer }
    public var              model          : String         { return identity.model }
    public weak var         parent         : Device?        { return _parent }
    public var              reachable      : Bool           { return true }
    public var              serialNumber   : String         { return identity.serialNumber }
    public private(set) var type           : DeviceType
    public var              bridgedDevices : [Device]       { return _bridgedDevices }
    public var              services       : [Service]      { return _services }
    
    // DeviceBackend
    public var       backend               : DeviceBackendDelegate!
    public var       defaultBackend        : Backend                 { return BackendDefault.main }
    public var       bridgedDeviceBackends : [DeviceBackend]         { return _bridgedDevices }
    public var       serviceBackends       : [ServiceBackend]        { return _services }
    
    // MARK: - Shadowed
    private weak var _parent         : DeviceBase?
    private var      _bridgedDevices = [DeviceBase]()
    private var      _services       = [ServiceBase]()
    
    // MARK: - Protected
    var observers = ObserverManager<DeviceObserver>()
    
    // MARK: - Initializers
    
    /**
     Initialize instance from device information.
     */
    public init(from deviceInfo: DeviceInfo)
    {
        identity = deviceInfo.identity
        name     = deviceInfo.name
        type     = deviceInfo.type
        
        backend = BackendDefault.main
    }
    
    /**
     Initialize instance from profile.
     */
    public init(_ parent: DeviceBase?, from profile: DeviceProfile)
    {
        backend = (parent != nil) ? parent!.defaultBackend : BackendDefault.main
        
        _parent         = parent
        identity        = profile.identity
        name            = profile.name
        type            = profile.type
        _bridgedDevices = profile.bridgedDevices.map { DeviceBase(self, from: $0) }
        _services       = profile.services.map { ServiceBase(self, from: $0) }
    }
    
    // MARK: - Observer Interface
    
    /**
     Add device observer.
     */
    public func addObserver(_ observer: DeviceObserver)
    {
        observers.add(observer)
    }
    
    /**
     Remove device observer.
     */
    public func removeObserver(_ observer: DeviceObserver)
    {
        observers.remove(observer)
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
            self.disconnected(for: nil) // TODO
            completion(nil)
        }
    }
    
    /**
     Open device.
     */
    public func open(completionHandler completion: @escaping (Error?) -> Void)
    {
        DispatchQueue.main.async {
            self.connected() // TODO
            completion(nil)
        }
    }
    
    public func connected()
    {
        observers.forEach { $0.deviceOpened(self) }
        
        for service in _services {
            service.connected()
        }
    
        for bridgedDevice in _bridgedDevices {
            bridgedDevice.connected()
        }
    }
    
    public func disconnected(for reason: Error?)
    {
        for bridgedDevice in _bridgedDevices {
            bridgedDevice.disconnected(for: reason)
        }
        
        for service in _services {
            service.disconnected()
        }
        
        observers.forEach { $0.deviceDidClose(self, for: reason) }
    }
    
    // MARK: - Mutators
    
    /**
     Update name.
     */
    public func updateName(_ name: String, completionHandler completion: @escaping (Error?) -> Void)
    {
        backend.device(self, updateName: name, completionHandler: completion)
    }
    
    // MARK: - DeviceBackend protocol
    
    /**
     Get bridged device with identifier.
     */
    public func getBridgedDevice(withIdentifier identifier: UUID) -> DeviceBase?
    {
        for bridgedDevice in _bridgedDevices {
            if bridgedDevice.identifier == identifier {
                return bridgedDevice
            }
        }
        
        return nil
    }
    
    /**
     Get service with identifier.
     */
    public func getService(withIdentifier identifier: UUID) -> ServiceBackend?
    {
        for service in _services {
            if service.identifier == identifier {
                return service
            }
        }
        
        return nil
    }
    
    /**
     Add bridged device.
     */
    public func addBridgedDevice(from profile: DeviceProfile, notify: Bool) -> DeviceBackend
    {
        let bridgedDevice = DeviceBase(self, from: profile)
        
        _bridgedDevices.append(bridgedDevice)
        
        if notify {
            observers.forEach { $0.device(self, didAdd: bridgedDevice) }
        }
        
        return bridgedDevice
    }
    
    /**
     Remove bridged device.
     */
    public func removeBridgedDevice(_ bridgedDevice: DeviceBackend, notify: Bool)
    {
        if let index = (_bridgedDevices.index { $0 === bridgedDevice }) {
            let device = _bridgedDevices[index]
            
            _bridgedDevices.remove(at: index)
            
            if notify {
                observers.forEach { $0.device(self, didRemove: device) }
            }
        }
    }
    
    /**
     Add service.
     */
    public func addService(_ service: ServiceBase, notify: Bool)
    {
        _services.append(service)
        
        if notify {
            observers.forEach { $0.device(self, didAdd: service) }
        }
    }
    
    /**
     Add service.
     */
    public func addService(from profile: ServiceProfile, notify: Bool) -> ServiceBackend
    {
        let service = ServiceBase(self, from: profile)
        
        _services.append(service)
        
        if notify {
            observers.forEach { $0.device(self, didAdd: service) }
        }
        
        return service
    }
    
    /**
     Remove service.
     */
    public func removeService(withIdentifier identifier: UUID, notify: Bool)
    {
        if let index = (_services.index { $0.identifier == identifier }) {
            let service = _services[index]
            
            _services.remove(at: index)
            
            if notify {
                observers.forEach { $0.device(self, didRemove: service) }
            }
        }
    }
    
    // MARK: - Mutators
    
    /**
     Update from profile.
     */
    public func update(from profile: DeviceProfile)
    {
        // update name
        if self.name != profile.name {
            self.name = profile.name
            observers.forEach { $0.deviceDidUpdateName(self) }
        }
        
        // update bridged devices{
        for profile in profile.bridgedDevices {
            if getBridgedDevice(withIdentifier: profile.identifier) == nil {
                _ = addBridgedDevice(from: profile, notify: true)
            }
        }
        
        // update services
        for profile in profile.services {
            if getService(withIdentifier: profile.identifier) == nil {
                _ = addService(from: profile, notify: true)
            }
        }
    }
    
    /**
     Update name.
     */
    public func updateName(_ name: String, notify: Bool)
    {
        self.name = name
        
        if notify {
            observers.forEach { $0.deviceDidUpdateName(self) }
        }
    }
    
}


// End of File
