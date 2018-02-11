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


/**
 MIST Version
 */
public enum MISTVersion: Int {
    case v1 = 1
}

/**
 Extends MISTVersion for the TXTCodable protocol.
 */
extension MISTVersion: TXTCodable {

    // MARK: - Private
    private enum TXTCodingKeys: String, CodingKey {
        case version = "vn"
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
        let version   = try container.decode(Int.self, forKey: .version)

        if let value = MISTVersion(rawValue: version) {
            self = value
        }
        else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Invalid value."))
        }
    }

    /**
     Encode to TXT.

     - Parameters:
        - encoder: A TXT encoder to which the instance will be encoded.
     */
    public func encode(to encoder: TXTEncoder) throws
    {
        let container = encoder.container(keyedBy: TXTCodingKeys.self)
        try container.encode(self.rawValue, forKey: .version)
    }

}


// End of File


