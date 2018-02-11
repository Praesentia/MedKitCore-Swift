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
import SecurityKit


/**
 Service responder.
 */
public class ServiceResponder: NSObject, NetServiceDelegate {

    // MARK: - Properties
    public let              domain     = "local."
    public let              identifier : String
    private(set) public var info       : NetServiceInfo
    private let             port       : UInt16

    // MARK: - Private
    private var netService : NetService

    /**
     Initialize instance.
     */
    public init(identifier: String, info: NetServiceInfo, port: UInt16)
    {
        self.identifier = identifier
        self.info       = info
        self.port       = port
        self.netService = NetService(domain: domain, type: info.type, name: identifier, port: Int32(port))

        super.init()

        netService.delegate = self
        try! netService.setTXTRecord(from: info)
    }
    
    /**

     */
    deinit
    {
        retract()
    }

    /**
     Update service information.
     */
    public func updateInfo(_ info: NetServiceInfo)
    {
        try! netService.setTXTRecord(from: info)
        self.info = info
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
    
    public func netServiceWillPublish(_ netService: NetService)
    {
    }
    
}

public extension ServiceResponder {

    /**
     Initialize instance.
     */
    public convenience init(deviceInfo: DeviceInfo, protocolType: ProtocolType, port: UInt16)
    {
        let identifier = SecurityManagerShared.main.randomBytes(count: 8).hexEncodedString
        let info       = MISTV1Info(deviceInfo: deviceInfo, protocolType: protocolType)

        self.init(identifier: identifier, info: info, port: port)
    }

    /**
     Initialize instance.
     */
    public convenience init(device: Device, protocolType: ProtocolType, port: UInt16)
    {
        let identifier = SecurityManagerShared.main.randomBytes(count: 8).hexEncodedString
        let info       = MISTV1Info(deviceInfo: DeviceInfo(from: device), protocolType: protocolType)

        self.init(identifier: identifier, info: info, port: port)
    }

    /**
     Initialize instance.
     */
    public func update(deviceInfo: DeviceInfo, protocolType: ProtocolType)
    {
        let info = MISTV1Info(deviceInfo: deviceInfo, protocolType: protocolType)
        updateInfo(info)
    }

}


// End of File
