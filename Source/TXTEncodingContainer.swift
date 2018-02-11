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


public class TXTEncodingContainer<Key: CodingKey> {

    // MARK: - Private
    private var storage: TXTEncodingStorage

    // MARK: - Initializers

    init(keyedBy: Key.Type, storage: TXTEncodingStorage)
    {
        self.storage = storage
    }

    // MARK: - Encoding

    public func encode(_ value: Int, forKey key: Key) throws
    {
        if let data = String(value).data(using: .utf8) {
            try storage.setValue(data, forKey: key)
        }
        else {
            throw EncodingError.invalidValue(key, EncodingError.Context(codingPath: [], debugDescription: "Invalid value."))
        }
    }

    public func encode(_ value: String, forKey key: Key) throws
    {
        if let data = value.data(using: .utf8) {
            try storage.setValue(data, forKey: key)
        }
        else {
            throw EncodingError.invalidValue(key, EncodingError.Context(codingPath: [], debugDescription: "Invalid value."))
        }
    }

    public func encode<T>(_ value: T) throws where T: TXTEncodable
    {
        return try value.encode(to: TXTEncoder(storage: storage))
    }

}


// End of File
