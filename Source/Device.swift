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
 Device protocol.
 */
public protocol Device: class {
    
    // MARK: - Properties
    
    /**
     Uniquely identifies the device.
     */
    var identifier: UUID { get }

    var identity: DeviceIdentity { get }
    
    var isOpen: Bool { get }
    
    /**
     The device name.  Device names are not necessarily unique.
     */
    var name: String { get }
    
    /**
     The manufacturer name.
     */
    var manufacturer: String { get }
    
    /**
     The device model.
     */
    var model: String { get }
    
    /**
     A reference to the bridging device, if any.
     */
    var parent: Device? { get }
    
    /**
     True if the device is reachable, otherwise false.
     */
    var reachable: Bool { get }
    
    /**
     The device serial number.
     */
    var serialNumber: String { get }
    
    /**
     The device type.
     */
    var type: DeviceType { get }
    
    /**
     Collection of bridged devices.
     */
    var bridgedDevices: [Device] { get }
    
    /**
     Collection of services.
     */
    var services: [Service] { get }
    
    // MARK: - Observer Interface
    
    /**
     Add observer.
     */
    func addObserver(_ observer: DeviceObserver)

    /**
     Remove observer.
     */
    func removeObserver(_ observer: DeviceObserver)
    
    // MARK: - Connectivity
    
    /**
     Close connection to device.
     */
    func close(completionHandler completion: @escaping (Error?) -> Void)
    
    /**
     Open connection to device.
     */
    func open(completionHandler completion: @escaping (Error?) -> Void)
    
    // MARK: - Mutators
    
    /**
     Update device name.
     
     - Parameters:
        - name:       The new name for the device.
        - completion: Completion handler.
     */
    func updateName(_ name: String, completionHandler completion: @escaping (Error?) -> Void)
    
}

public extension Device {

    var profile: DeviceProfile { return DeviceProfile(for: self) }

}


// End of File
