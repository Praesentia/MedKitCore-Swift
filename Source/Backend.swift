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
 Backend base class.
 */
class BackendDefault: Backend {
    
    static let main = BackendDefault()
    
    let isOpen = true

    // MARK: - DeviceBackendDelegate
    
    func deviceClose(_ device: DeviceBackend, for reason: Error?, completionHandler completion: @escaping (Error?) -> Void)
    {
        DispatchQueue.main.async { completion(nil) }
    }
    
    func deviceOpen(_ device: DeviceBackend, completionHandler completion: @escaping (Error?) -> Void)
    {
        DispatchQueue.main.async { completion(MedKitError.unreachable) }
    }
    
    func device(_ device: DeviceBackend, updateName name: String, completionHandler completion: @escaping (Error?) -> Void)
    {
        DispatchQueue.main.async { completion(MedKitError.notSupported) }
    }
    
    // MARK: - ServiceBackendDelegate
    
    func service(_ service: ServiceBackend, updateName name: String, completionHandler completion: @escaping (Error?) -> Void)
    {
        DispatchQueue.main.async { completion(MedKitError.notSupported) }
    }
    
    // MARK: - ResourceBackendDelegate

    func resourceAsync(_ resource: ResourceBackend, message: AnyCodable)
    {
    }

    func resourceSync(_ resource: ResourceBackend, message: AnyCodable, completionHandler completion: @escaping (AnyCodable?, Error?) -> Void)
    {
        DispatchQueue.main.async { completion(nil, MedKitError.notSupported) }
    }

    func resourceEnableNotification(_ resource: ResourceBackend, enable: Bool, completionHandler completion: @escaping (Error?) -> Void)
    {
        DispatchQueue.main.async { completion(MedKitError.notSupported) }
    }
    
    func resource(_ resource: ResourceBackend, didCallWith message: AnyCodable, completionHandler completion: @escaping (AnyCodable?, Error?) -> Void)
    {
        DispatchQueue.main.async { completion(nil, MedKitError.notSupported) }
    }

    func resource(_ resource: ResourceBackend, didNotify notification: AnyCodable)
    {
    }
    
}


// End of File
