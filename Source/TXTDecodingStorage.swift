/*
 -----------------------------------------------------------------------------
 This source file is part of MedKitCore.

 Copyright 2018 Jon Griffeth

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
 TXT Decoding Storage

 - Requirement: RFC-6763
 */
class TXTDecodingStorage {

    // MARK: - Private
    private var txt: [String : Data]

    // MARK: - Initializers

    init(from data: Data)
    {
        txt = NetService.dictionary(fromTXTRecord: data)
    }

    // MARK: - Getters

    func getValue(forKey key: CodingKey) throws -> Data
    {
        if let value = txt[key.stringValue] {
            return value
        }

        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Key not found."))
    }

    func getValueIfPresent(forKey key: CodingKey) -> Data?
    {
        return txt[key.stringValue]
    }

}


// End of File
