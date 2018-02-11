/*
 -----------------------------------------------------------------------------
 This source file is part of MedKitCore.

 Copyright 2017-2018 Jon Griffeth

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
 MIST V1 Information
 */
public struct MISTV1Info: NetServiceInfo, TXTDecodable {

    // MARK: - Properties
    public let type         = "_mist._tcp"
    public var version      : MISTVersion
    public var deviceInfo   : DeviceInfo
    public var protocolType : ProtocolType

    // MARK: - Private
    private enum TXTCodingKeys: String, CodingKey {
        case manufacturer = "mf"
        case model        = "md"
        case name         = "dn"
        case serialNumber = "sn"
        case type         = "dt"
        case version      = "vn"
    }

    // MARK - Initializers

    /**
     Initializer

     - Parameters:
        - deviceInfo:
        - protocolType:
     */
    public init(deviceInfo: DeviceInfo, protocolType: ProtocolType)
    {
        self.version      = .v1
        self.deviceInfo   = deviceInfo
        self.protocolType = protocolType
    }

    // MARK: - TXTCodable

    /**
     Initialize from TXT.

     - Parameters:
        - decoder: A TXT decoder from which the instance will be initialized.
     */
    public init(from decoder: TXTDecoder) throws
    {
        let container = decoder.container(keyedBy: TXTCodingKeys.self)

        version      = try container.decode(MISTVersion.self)
        deviceInfo   = try container.decode(DeviceInfo.self)
        protocolType = try container.decode(ProtocolType.self)
    }

    /**
     Encode to TXT.

     - Parameters:
        - encoder: A TXT encoder to which the instance will be encoded.
     */
    public func encode(to encoder: TXTEncoder) throws
    {
        let container = encoder.container(keyedBy: TXTCodingKeys.self)

        try container.encode(version)
        try container.encode(deviceInfo)
        try container.encode(protocolType)
    }

}


// End of File

