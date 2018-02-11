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
 Device type.
 */
public class DeviceType: TXTCodable, Codable {
    
    // MARK: - Properties
    
    /**
     Device type identifier.
     
     A type 5 UUID derived from the device type name.
     */
    public private(set) lazy var identifier: UUID = DeviceType.identifier(from: self.name)
    
    /**
     Device type name.
     */
    public let name: String

    // MARK: - Private
    private enum TXTCodingKeys: String, CodingKey {
        case name = "dt"
    }
    
    // MARK: - Initializers
    
    /**
     Initialize instance.
     
     Initializes the DeviceType from it's string representation.
     
     The name should preferrably be in cased form, as the name will be used as
     a default for the localized description.
     
     - Parameters:
        - name: String representation of the device type.
     */
    public init(named name: String)
    {
        self.name = name
    }

    // MARK: - TXTCodable

    public required init(from decoder: TXTDecoder) throws
    {
        let container = decoder.container(keyedBy: TXTCodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
    }

    public func encode(to encoder: TXTEncoder) throws
    {
        let container = encoder.container(keyedBy: TXTCodingKeys.self)
        try container.encode(name, forKey: .name)
    }

    // MARK: - Codable

    required public init(from decoder: Decoder) throws
    {
        let container = try decoder.singleValueContainer()
        name = try container.decode(String.self)
    }

    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.singleValueContainer()
        try container.encode(name)
    }

    /**
     Device type identifier.

     Calculates a type 5 UUID for a device type with the specified name.  The name
     is case-insensitive.
     */
    public static func identifier(from name: String) -> UUID
    {
        let digest = SecurityManagerShared.main.digest(ofType: .sha1)

        digest.update(uuid: UUIDNSDeviceType)
        digest.update(string: name.lowercased())

        return UUID(fromSHA1: digest.final())
    }
    
}

extension DeviceType: Equatable, Hashable {

    public var hashValue: Int { return identifier.hashValue }

    public static func ==(lhs: DeviceType, rhs: DeviceType) -> Bool
    {
        return lhs.identifier == rhs.identifier
    }

}


// End of File
