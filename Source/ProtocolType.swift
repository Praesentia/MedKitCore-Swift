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
 Protocol type.
 */
public class ProtocolType: Codable {

    // MARK: - Properties

    /**
     Protocol identifier.
     */
    public let identifier: String

    public var localizedDescription : String? { return ProtocolPluginManager.shared.findProtocol(forType: self)?.localizedDescription }

    /**
     Protocol text.
     */
    public var text: String { return identifier }

    // MARK: - Initializers

    /**
     Initialize instance.

     Initializes the DeviceType from it's string representation.

     The name should preferrably be in cased form, as the name will be used as
     a default for the localized description.

     - Parameters:
        - name: String representation of the device type.
     */
    public init(withIdentifier identifier: String)
    {
        self.identifier = identifier
    }

    /**
     Initialize instance.

     Initializes the DeviceType from it's string representation.

     The name should preferrably be in cased form, as the name will be used as
     a default for the localized description.

     - Parameters:
        - text: String representation of the device type.
     */
    public init?(fromText text: String?)
    {
        if let text = text {
            self.identifier = text
        }
        else {
            return nil
        }
    }

    // MARK: - Codable

    required public init(from decoder: Decoder) throws
    {
        let container = try decoder.singleValueContainer()
        identifier = try container.decode(String.self)
    }

    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.singleValueContainer()
        try container.encode(identifier)
    }

}


// End of File
