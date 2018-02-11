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


public class TXTDecodingContainer<Key: CodingKey> {

    // MARK: - Private
    private let storage: TXTDecodingStorage

    // MARK: - Initializers

    init(keyedBy: Key.Type, storage: TXTDecodingStorage)
    {
        self.storage = storage
    }

    // MARK: - Decoding

    public func decode(_ type: Int.Type, forKey key: Key) throws -> Int
    {
        let data = try storage.getValue(forKey: key)

        if let string = String(data: data, encoding: .utf8) {
            if let value = Int(string) {
                return value
            }
        }

        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Invalid value."))
    }

    public func decode(_ type: String.Type, forKey key: Key) throws -> String
    {
        let data = try storage.getValue(forKey: key)

        if let string = String(data: data, encoding: .utf8) {
            return string
        }

        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Invalid value."))
    }

    public func decode<T>(_ type: T.Type) throws -> T where T: TXTDecodable
    {
        return try T(from: TXTDecoder(storage: storage))
    }

}


// End of File
