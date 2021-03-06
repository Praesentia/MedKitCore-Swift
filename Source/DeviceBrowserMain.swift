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
 Device Browser
 */
public class DeviceBrowserMain: DeviceBrowser, ServiceBrowserDelegate, NetDeviceObserver {
    
    // MARK: - Properties
    public static let shared: DeviceBrowser = DeviceBrowserMain()
    
    public var devices : [DeviceProxy] { return _devices }         //: Device list.
    
    // MARK: - Shadowed
    private var _devices  = [DeviceProxyNet]()
    
    // MARK: - Private
    private let browser   = ServiceBrowser()
    private var observers = [DeviceBrowserObserver]() //: Observers
    
    // MARK: - Initializers
    
    /**
     Initialize instance.
     */
    private init()
    {
        browser.delegate = self
    }
    
    // MARK: - Observer Interface
    
    public func addObserver(_ observer: DeviceBrowserObserver)
    {
        observers.append(observer)
    }
    
    public func removeObserver(_ observer: DeviceBrowserObserver)
    {
        if let index = observers.index(where: { $0 === observer }) {
            observers.remove(at: index)
        }
    }
    
    // MARK: - Suspend.Resume
    
    public func resume()
    {
        browser.resume()
        observers.forEach { $0.deviceBrowserDidUpdate(self) }
    }
    
    public func suspend()
    {
        browser.suspend()
    }
    
    // MARK: - Search
    
    /**
     Start browsing domain.
     */
    public func startBrowsing(domain: String)
    {
        browser.startBrowsing(domain: domain)
    }
    
    /**
     Stop browsing all domains.
     */
    public func stopBrowsing()
    {
        browser.stopBrowsing()
    }
    
    /**
     Stop browsing domain.
     */
    public func stopBrowsing(domain: String)
    {
        browser.stopBrowsing(domain: domain)
    }
    
    // MARK: - Private
    
    /**
     */
    private func internDevice(from deviceInfo: DeviceInfo) -> DeviceProxyNet
    {
        let device = DeviceProxyNetCache.main.findDevice(with: deviceInfo)
        
        _devices.append(device)
        return device
    }
    
    /**
     Remove device.
     */
    private func removeDevice(withIdentifier identifier: UUID) -> DeviceProxyNet?
    {
        var device: DeviceProxyNet?
        
        if let index = _devices.index(where: { $0.identifier == identifier }) {
            device = _devices[index]
            _devices.remove(at: index)
        }
        
        return device
    }
    
    // MARK: - ServiceBrowserDelegate
    
    /**
     Did add device.
     */
    func serviceBrowser(_ serviceBrowser: ServiceBrowser, didAdd netDevice: NetDevice)
    {
        if _devices.find(where: { $0.identifier == netDevice.info.identifier}) == nil {
            let device = internDevice(from: netDevice.info)
            
            netDevice.observer = self
            for port in netDevice.ports {
                device.addPort(port)
            }
            
            observers.forEach { $0.deviceBrowser(self, didAdd: device) }
        }
    }
    
    /**
     Did remove device.
     */
    func serviceBrowser(_ serviceBrowser: ServiceBrowser, didRemove netDevice: NetDevice)
    {
        netDevice.observer = nil
        
        if let device = removeDevice(withIdentifier: netDevice.info.identifier) {
            device.removeAllPorts()
            device.close(for: MedKitError.suspended) // TODO: fix reason
            observers.forEach { $0.deviceBrowser(self, didRemove: device) }
        }
    }
    
    // MARK: - NetDeviceDelegate
    
    /**
     Did add port.
     */
    func netDevice(_ netDevice: NetDevice, didAdd port: NetPortFactory)
    {
        if let device = _devices.find(where: { $0.identifier == netDevice.info.identifier}) {
            device.addPort(port)
        }
    }
    
    /**
     Did remove port.
     */
    func netDevice(_ netDevice: NetDevice, didRemove port: NetPortFactory)
    {
        if let device = _devices.find(where: { $0.identifier == netDevice.info.identifier}) {
            device.removePort(port)
        }
    }
    
}


// End of File
