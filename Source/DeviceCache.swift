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
 Device Cache
 */
public class DeviceCache {
    
    public static let main = DeviceCache();
    
    private struct Entry {
        unowned let device: DeviceProxyBase;
        
        init(_ device: DeviceProxyBase)
        {
            self.device = device;
        }
    }
    
    private var cache = [UUID : Entry]();
    
    public func findDevice(with identifier: UUID) -> DeviceProxy?
    {
        return cache[identifier]?.device;
    }
    
    func findDevice(with deviceInfo: DeviceInfo) -> DeviceProxyBase
    {
        let device: DeviceProxyBase;
        
        if let entry = cache[deviceInfo.identifier] {
            device = entry.device;
        }
        else {
            device = DeviceProxyBase(from: deviceInfo);
            cache[deviceInfo.identifier] = Entry(device);
        }
        
        return device;
    }
    
    public func findDevice(from profile: JSON) -> DeviceProxy
    {
        return findDevice(with: DeviceInfo(from: profile));
    }
    
    func removeDevice(with identifier: UUID)
    {
        cache[identifier] = nil;
    }
    
}


// End of File
