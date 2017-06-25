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
 Service responder.
 */
public class ServiceResponder: NSObject, NetServiceDelegate {
    
    private let ServiceDomain  = "local."
    private let ServiceType    = "_mist._tcp"
    private let ServiceVersion = "1"
    private let identifier     = SecurityManagerShared.main.randomBytes(count: 8).hexEncodedString
    private var netService     : NetService
    
    /**
     Initialize instance.
     */
    public init(deviceInfo: DeviceInfo, protocolType: String, port: UInt16)
    {
        netService = NetService(domain: ServiceDomain, type: ServiceType, name: identifier, port: Int32(port))
        
        super.init()
        
        netService.delegate = self
        netService.setTXTRecord(makeTXTRecord(deviceInfo: deviceInfo, protocolType: protocolType))
    }
    
    /**
     Initialize instance.
     */
    public init(device: Device, protocolType: String, port: UInt16)
    {
        netService = NetService(domain: ServiceDomain, type: ServiceType, name: identifier, port: Int32(port))
        
        super.init()
        
        netService.delegate = self
        netService.setTXTRecord(makeTXTRecord(device: device, protocolType: protocolType))
    }
    
    /**

     */
    deinit
    {
        retract()
    }
    
    /**
     Publish service.
     */
    public func publish()
    {
        netService.publish()
    }
    
    /**
     Retract service.
     */
    public func retract()
    {
        netService.stop()
    }
    
    private func makeTXTRecord(device: Device, protocolType: String) -> Data
    {
        var txt = [String : Data]()
        
        txt["dn"] = device.name.data(using: .utf8)
        txt["dt"] = device.type.name.data(using: .utf8)
        txt["mf"] = device.manufacturer.data(using: .utf8)
        txt["md"] = device.model.data(using: .utf8)
        txt["sn"] = device.serialNumber.data(using: .utf8)
        txt["pr"] = protocolType.data(using: .utf8)
        txt["vn"] = ServiceVersion.data(using: .utf8)
        
        return NetService.data(fromTXTRecord: txt)
    }
    
    private func makeTXTRecord(deviceInfo: DeviceInfo, protocolType: String) -> Data
    {
        var txt = [String : Data]()
        
        txt["dn"] = deviceInfo.name.data(using: .utf8)
        txt["dt"] = deviceInfo.type.name.data(using: .utf8)
        txt["mf"] = deviceInfo.manufacturer.data(using: .utf8)
        txt["md"] = deviceInfo.model.data(using: .utf8)
        txt["sn"] = deviceInfo.serialNumber.data(using: .utf8)
        txt["pr"] = protocolType.data(using: .utf8)
        txt["vn"] = ServiceVersion.data(using: .utf8)
        
        return NetService.data(fromTXTRecord: txt)
    }
    
    public func netServiceWillPublish(_ netService: NetService)
    {
    }
    
}


// End of File
