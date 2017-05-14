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
 Device Proxy Cache
 */
public class DeviceProxyNetCache {
    
    // MARK: - Class Properties
    public static let main = DeviceProxyNetCache();
    
    // MARK: - Private
    
    private struct Entry {
        unowned let device: DeviceProxyNet;
        
        init(_ device: DeviceProxyNet)
        {
            self.device = device;
        }
    }
    
    private var cache = [UUID : Entry]();
    
    // MARK: - Cache Management
    
    /**
     Intern device with info.
     
     - Parameters:
        - deviceInfo: Device information.
     */
    private func internDevice(with deviceInfo: DeviceInfo) -> DeviceProxyNet
    {
        let device = DeviceProxyNet(from: deviceInfo);
        
        cache[device.identifier] = Entry(device);
        return device;
    }
    
    /**
     Remove device with identifier.
     
     - Parameters:
     - identifier: Device identifier.
     */
    func removeDevice(with identifier: UUID)
    {
        cache[identifier] = nil;
    }
    
    // MARK: - Search
    
    /**
     Find device with identifier.
     
     - Parameters:
        - identifier: Device identifier.
     */
    public func findDevice(with identifier: UUID) -> DeviceProxy?
    {
        return cache[identifier]?.device;
    }
    
    /**
     Find device with info.
     
     - Parameters:
        - deviceInfo: Device information.
     */
    func findDevice(with deviceInfo: DeviceInfo) -> DeviceProxyNet
    {
        let device: DeviceProxyNet;
        
        if let entry = cache[deviceInfo.identifier] {
            device = entry.device;
        }
        else {
            device = internDevice(with: deviceInfo);
        }
        
        return device;
    }
    
    /**
     Find device from profile.
     
     - Parameters:
        - profile: Device profile.
     */
    public func findDevice(from profile: JSON) -> DeviceProxy
    {
        return findDevice(with: DeviceInfo(from: profile));
    }
    
}


// End of File
