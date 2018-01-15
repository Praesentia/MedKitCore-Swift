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


public enum TXTVersion {
    case v1
}

/**
 Device metadata.
 */
public struct DeviceIdentity: Codable {

    // MARK: - Properties
    public var identifier   : UUID { return self.generateIdentifier() }
    public var manufacturer : String
    public var model        : String
    public var serialNumber : String

    // MARK: - Private
    private enum CodingKeys: CodingKey {
        case manufacturer
        case model
        case name
        case serialNumber
        case type
    }

    private static let txtKeyManufacturer = "mf"
    private static let txtKeyModel        = "md"
    private static let txtKeySerialNumber = "sn"

    // MARK: - Initializers

    public init()
    {
        manufacturer = ""
        model        = ""
        serialNumber = ""
    }

    /**
     Initialize instance from profile.

     - Parameters:
        - profile:
     */
    public init(from device: Device)
    {
        manufacturer = device.manufacturer
        model        = device.model
        serialNumber = device.serialNumber
    }

    /**
     Initialize instance from TXT dictionary.

     - Parameters:
        - txt: Dictionary of key/value pairs derived from an associated TXT
               record.
     */
    init(fromTXT txt: [String : String], version: TXTVersion)
    {
        manufacturer = txt[DeviceIdentity.txtKeyManufacturer]!
        model        = txt[DeviceIdentity.txtKeyModel]!
        serialNumber = txt[DeviceIdentity.txtKeySerialNumber]!
    }

    // MARK: - Codable

    public init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        manufacturer = try container.decode(String.self, forKey: .manufacturer)
        model        = try container.decode(String.self, forKey: .model)
        serialNumber = try container.decode(String.self, forKey: .serialNumber)
    }

    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(manufacturer, forKey: .manufacturer)
        try container.encode(model, forKey: .model)
        try container.encode(serialNumber, forKey: .serialNumber)
    }

    // MARK: - Private

    /**
     Generate a type 5 UUID from device identity.
     */
    private func generateIdentifier() -> UUID
    {
        let digest = SecurityManagerShared.main.digest(ofType: .sha1)

        digest.update(uuid:           UUIDNSDevice)
        digest.update(prefixedString: manufacturer)
        digest.update(prefixedString: model)
        digest.update(prefixedString: serialNumber)

        return UUID(fromSHA1: digest.final())
    }

}


// End of File

