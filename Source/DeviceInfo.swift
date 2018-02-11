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
 Device metadata.
 */
public struct DeviceInfo: TXTCodable, Codable {

    // MARK: - Properties
    public var identifier   : UUID { return identity.identifier }
    public var identity     : DeviceIdentity
    public var name         : String
    public var type         : DeviceType
    
    // MARK: - Private
    private enum TXTCodingKeys: String, CodingKey {
        case name = "dn"
    }

    private enum CodingKeys: CodingKey {
        case identity
        case name
        case type
    }

    // MARK: - Initializers

    /**
     Initialize instance.
     */
    public init()
    {
        identity = DeviceIdentity()
        name     = ""
        type     = DeviceType(named: "")
    }

    /**
     Initialize instance from device.

     - Parameters:
        - device:
     */
    public init(from device: Device)
    {
        identity = DeviceIdentity(from: device)
        name     = device.name
        type     = device.type
    }

    /**
     Initialize instance from profile.

     - Parameters:
        - profile:
     */
    public init(from profile: DeviceProfile)
    {
        identity = profile.identity
        name     = profile.name
        type     = profile.type
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

        identity = try container.decode(DeviceIdentity.self)
        name     = try container.decode(String.self, forKey: .name)
        type     = try container.decode(DeviceType.self)
    }

    /**
     Encode to TXT.

     - Parameters:
        - encoder: A TXT encoder to which the instance will be encoded.
     */
    public func encode(to encoder: TXTEncoder) throws
    {
        let container = encoder.container(keyedBy: TXTCodingKeys.self)

        try container.encode(identity)
        try container.encode(name, forKey: .name)
        try container.encode(type)
    }

    // MARK: - Codable

    public init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        identity = try container.decode(DeviceIdentity.self, forKey: .identity)
        name     = try container.decode(String.self,         forKey: .name)
        type     = try container.decode(DeviceType.self,     forKey: .type)
    }

    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(identity, forKey: .identity)
        try container.encode(name,     forKey: .name)
        try container.encode(type,     forKey: .type)
    }

}

extension DeviceInfo: Equatable
{

    public static func ==(lhs: DeviceInfo, rhs: DeviceInfo) -> Bool
    {
        return lhs.identity == rhs.identity && lhs.name == rhs.name && lhs.type == rhs.type
    }

}


// End of File
