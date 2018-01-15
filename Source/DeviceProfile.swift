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
import SecurityKit


public struct DeviceProfile: Codable {

    // MARK: - Properties
    public var identifier     : UUID { return identity.identifier }
    public var identity       : DeviceIdentity
    public var name           : String
    public var type           : DeviceType
    public var bridgedDevices : [DeviceProfile]
    public var services       : [ServiceProfile]

    // MARK: - Private
    private enum CodingKeys: CodingKey {
        case identity
        case name
        case type
        case bridgedDevices
        case services
    }

    // MARK: - Initializers

    public init(from deviceInfo: DeviceInfo)
    {
        identity       = deviceInfo.identity
        name           = deviceInfo.name
        type           = deviceInfo.type
        bridgedDevices = []
        services       = []
    }

    public init(for device: Device)
    {
        identity       = DeviceIdentity(from: device)
        name           = device.name
        type           = device.type
        bridgedDevices = device.bridgedDevices.map { $0.profile }
        services       = device.services.map { $0.profile }
    }

    // MARK: - Codable

    public init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        identity       = try container.decode(DeviceIdentity.self,   forKey: .identity)
        name           = try container.decode(String.self,           forKey: .name)
        type           = try container.decode(DeviceType.self,       forKey: .type)
        bridgedDevices = try container.decode([DeviceProfile].self,  forKey: .bridgedDevices)
        services       = try container.decode([ServiceProfile].self, forKey: .services)
    }

    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(identity,       forKey: .identity)
        try container.encode(name,           forKey: .name)
        try container.encode(type,           forKey: .type)
        try container.encode(bridgedDevices, forKey: .bridgedDevices)
        try container.encode(services,       forKey: .services)
    }

}


// End of File
