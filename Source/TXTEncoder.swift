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
 TXT Encoder

 An encoder suitable for encoding a TXTEncodable object as the contents of a
 DNS TXT record consisting of key/value pairs.

 - Requirement: RFC-6763
 */
public class TXTEncoder {

    // MARK: - Properties
    public var data: Data { return storage.data }

    // MARK: - Private
    private let storage: TXTEncodingStorage

    // MARK: - Initializers

    public init()
    {
        storage = TXTEncodingStorage()
    }

    init(storage: TXTEncodingStorage)
    {
        self.storage = storage
    }

    // MARK: - Containers

    public func container<Key>(keyedBy: Key.Type) -> TXTEncodingContainer<Key> where Key: CodingKey
    {
        return TXTEncodingContainer(keyedBy: Key.self, storage: storage)
    }

}


// End of File

