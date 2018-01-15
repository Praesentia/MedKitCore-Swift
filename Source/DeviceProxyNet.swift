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
 Network device proxy.
 */
public class DeviceProxyNet: DeviceBase, DeviceProxy {
    
    // MARK: - Properties
    override public var isOpen         : Bool          { return netBackend.isOpen }
    override public var defaultBackend : Backend       { return netBackend }
    public var          ports          : [PortFactory] { return netBackend.ports.ports }
    override public var reachable      : Bool          { return netBackend.reachable }

    // MARK: - Private
    private var netBackend: NetBackend!
    
    // MARK: - Initializers
    
    /**
     Initialize instance from device information.
     */
    override public init(from deviceInfo: DeviceInfo)
    {
        super.init(from: deviceInfo)
        netBackend = NetBackend(device: self)
        backend    = netBackend
    }
    
    /**
     Initialize instance from profile.
     */
    override public init(_ parent: DeviceBase?, from profile: DeviceProfile)
    {
        super.init(parent, from: profile)
        netBackend = NetBackend(device: self)
        backend    = netBackend
    }
    
    /**
     Deinitialize instance.
     */
    deinit
    {
        DeviceProxyNetCache.main.removeDevice(with: identifier)
    }
    
    // MARK: - Connectivity
    
    /**
     Close connection to device.
     */
    override func close(for reason: Error?)
    {
        if netBackend.isOpen {
            netBackend.deviceClose(self, for: reason) { error in }
        }
    }
    
    /**
     Close connection to device, with completion handler.
     */
    override public func close(completionHandler completion: @escaping (Error?) -> Void)
    {
        let sync = Sync()
        
        if netBackend.isOpen {
            sync.incr()
            netBackend.deviceClose(self, for: nil) { error in
                sync.decr(error)
            }
        }
        
        sync.close(completionHandler: completion)
    }
    
    /**
     Open device.
     */
    override public func open(completionHandler completion: @escaping (Error?) -> Void)
    {
        let sync = Sync()
        
        if !netBackend.isOpen {
            sync.incr()
            netBackend.deviceOpen(self) { error in
                sync.decr(error)
            }
        }
            
        sync.close(completionHandler: completion)
    }
    
    // MARK: - Port Interface
    
    /**
     Add port.
     */
    func addPort(_ port: NetPortFactory)
    {
        let reachable = netBackend.reachable
        
        netBackend.ports.addPort(port)
        observers.forEach { $0.device(self, didAdd: port) }
        
        if !reachable && netBackend.reachable {
            observers.forEach { $0.deviceDidUpdateReachability(self) }
        }
    }
    
    /**
     Remove port.
     */
    func removePort(_ port: NetPortFactory)
    {
        let reachable = netBackend.reachable
        
        netBackend.ports.removePort(port)
        observers.forEach { $0.device(self, didRemove: port) }
        
        if reachable && !netBackend.reachable {
            observers.forEach { $0.deviceDidUpdateReachability(self) }
        }
    }
    
    /**
     Remove all ports.
     */
    func removeAllPorts()
    {
        let reachable = netBackend.reachable
        
        netBackend.ports.removeAllPorts()
        if reachable {
            observers.forEach { $0.deviceDidUpdateReachability(self) }
        }
    }
    
}


// End of File
