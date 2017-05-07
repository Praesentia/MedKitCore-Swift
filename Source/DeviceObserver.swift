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
 Device observer.
 */
public protocol DeviceObserver: class {
    
    func deviceDidUpdateName(_ device: Device);
    
    // MARK: - Bridged Devices
    func device(_ device: Device, didAdd bridgedDevice: Device);
    func device(_ device: Device, didRemove bridgedDevice: Device);
    
    // MARK: - Services
    func device(_ device: Device, didAdd service: Service);
    func device(_ device: Device, didRemove service: Service);
    
    // MARK: - Connectivity
    func deviceOpened(_ device: Device);
    func deviceDidClose(_ device: Device, reason: Error?);
    func deviceDidUpdateReachability(_ device: DeviceProxy);
    func device(_ device: DeviceProxy, didAdd port: PortFactory);
    func device(_ device: DeviceProxy, didRemove port: PortFactory);
    
}

/**
 Device observer defaults.
 */
public extension DeviceObserver {
    
    public func deviceDidUpdateName(_ device: Device) {}
    public func deviceOpened(_ device: Device) {}
    public func deviceDidClose(_ device: Device, reason: Error?) {}
    public func device(_ device: Device, didAdd bridgedDevice: Device) {}
    public func device(_ device: Device, didRemove bridgedDevice: Device) {}
    public func device(_ device: Device, didAdd service: Service) {}
    public func device(_ device: Device, didRemove service: Service) {}
    
    public func deviceDidUpdateReachability(_ device: DeviceProxy) {}
    public func device(_ device: DeviceProxy, didAdd port: PortFactory) {}
    public func device(_ device: DeviceProxy, didRemove port: PortFactory) {}
    
}



// End of File
