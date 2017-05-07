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
 DeviceBrowser delegate.
 */
public protocol DeviceBrowserObserver: class {
    
    /**
     Did update.
     */
    func deviceBrowserDidUpdate(_ deviceBrowser: DeviceBrowser)
    
    /**
     Did add device.
     
     This method is called after a new device has been discovered and added to
     the device list.
     */
    func deviceBrowser(_ deviceBrowser: DeviceBrowser, didAdd device: DeviceProxy)
    
    /**
     Did remove device.
     
     This method is called when a device is no longer available and has been
     removed from the device list.
     */
    func deviceBrowser(_ deviceBrowser: DeviceBrowser, didRemove device: DeviceProxy)
    
}

public extension DeviceBrowserObserver {
    
    func deviceBrowserDidUpdate(_ deviceBrowser: DeviceBrowser) {}
    func deviceBrowser(_ deviceBrowser: DeviceBrowser, didAdd device: DeviceProxy) {}
    func deviceBrowser(_ deviceBrowser: DeviceBrowser, didRemove device: DeviceProxy) {}
    
}



// End of File
