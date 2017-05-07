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
 Device backend protocol.
 
 Device interface for backed device delegates.
 
 - SeeAlso: DeviceBackendDelegate
 */
public protocol DeviceBackend: class {
    
    var backend               : DeviceBackendDelegate! { get set }
    var identifier            : UUID                   { get }
    var defaultBackend        : Backend                { get }
    var bridgedDeviceBackends : [DeviceBackend]        { get }
    var serviceBackends       : [ServiceBackend]       { get }
    
    // bridged devices
    func getBridgedDevice(withIdentifier identifier: UUID) -> DeviceBase?;
    func addBridgedDevice(from profile: JSON, notify: Bool) -> DeviceBackend;
    func removeBridgedDevice(_ bridgedDevice: DeviceBackend, notify: Bool);
    
    // services
    func getService(withIdentifier identifier: UUID) -> ServiceBackend?;
    func addService(from profile: JSON, notify: Bool) -> ServiceBackend;
    func removeService(withIdentifier identifier: UUID, notify: Bool);
    
    // updates
    func update(from profile: JSON);
    func updateName(_ name: String, notify: Bool);
    
}


// End of File
