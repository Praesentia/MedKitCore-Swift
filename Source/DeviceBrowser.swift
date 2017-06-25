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


import Foundation


/**
 DeviceBrowser protocol.
 
 DeviceBrower provides a mechanism for the automatic discovery of networked devices.
 */
public protocol DeviceBrowser: class {
    
    // MARK: - Properties
    
    var devices: [DeviceProxy] { get }
    
    // MARK: - Observer Interface
    
    func addObserver(_ observer: DeviceBrowserObserver)
    func removeObserver(_ observer: DeviceBrowserObserver)
    
    // MARK: - Suspend/Resume
    
    func resume()
    func suspend()
    
    // MARK: - Search
    
    func startBrowsing(domain: String)
    func stopBrowsing()
    func stopBrowsing(domain: String)

}


// End of File
