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
 Resource type.
 */
public class ResourceProtocolType: Codable {

    // MARK: - Properties

    /**
     Resource type identifier.
     */
    public let identifier: UUID

    // MARK: - Initializers

    /**
     Initialize instance.
     */
    public init()
    {
        self.identifier = UUID.null
    }

    /**
     Initialize instance.

     Initializes the ResourceSubject from the resource identifier.

     - Parameters:
        - identifier: The resource type identifier.
     */
    public init(withIdentifier identifier: UUID)
    {
        self.identifier = identifier
    }

    // MARK: - Codable

    required public init(from decoder: Decoder) throws
    {
        let container = try decoder.singleValueContainer()
        identifier = try container.decode(UUID.self)
    }

    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.singleValueContainer()
        try container.encode(identifier)
    }

}


// End of File
