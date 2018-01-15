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


public struct ServiceProfile: Codable {

    private enum CodingKeys: CodingKey {
        case identifier
        case name
        case type
        case resources
    }

    public var identifier : UUID
    public var name       : String
    public var type       : ServiceType
    public var resources  : [ResourceProfile]

    public init()
    {
        identifier = UUID.null
        name       = String()
        type       = ServiceType()
        resources  = [ResourceProfile]()
    }

    public init(for service: Service)
    {
        identifier = service.identifier
        name       = service.name
        type       = service.type
        resources  = service.resources.map { $0.profile }
    }

    public init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        identifier = try container.decode(UUID.self, forKey: .identifier)
        name       = try container.decode(String.self, forKey: .name)
        type       = try container.decode(ServiceType.self, forKey: .type)
        resources  = try container.decode([ResourceProfile].self, forKey: .resources)
    }

    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(identifier, forKey: .identifier)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(resources, forKey: .resources)
    }

}


// End of File

