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


public struct ResourceProfile: Codable {

    // MARK: - Public
    public var access        : Access               = .readWrite
    public var identifier    : UUID                 = UUID.null
    public var notifications : Bool                 = true
    public var proto         : ResourceProtocolType = ResourceProtocolType()
    public var subject       : ResourceSubject      = ResourceSubject()

    // MARK: - Private
    private enum CodingKeys: CodingKey {
        case access
        case identifier
        case notifications
        case proto
        case subject
    }

    public init()
    {
    }

    public init(proto: ResourceProtocolType, subject: ResourceSubject)
    {
        self.proto   = proto
        self.subject = subject
    }

    public init(for resource: Resource)
    {
        access        = resource.access
        identifier    = resource.identifier
        notifications = resource.notifications
        proto         = resource.proto
        subject       = resource.subject
    }

    public init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        access        = try container.decode(Access.self, forKey: .access)
        identifier    = try container.decode(UUID.self, forKey: .identifier)
        notifications = try container.decode(Bool.self, forKey: .notifications)
        proto         = try container.decode(ResourceProtocolType.self, forKey: .proto)
        subject       = try container.decode(ResourceSubject.self, forKey: .subject)
    }

    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(access, forKey: .access)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(notifications, forKey: .notifications)
        try container.encode(proto, forKey: .proto)
        try container.encode(subject, forKey: .subject)
    }

}


// End of File
