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
 TXT Decoder

 An Decoder suitable for decoding a TXTDecodable object from the contents of a
 DNS TXT record consisting of key/value pairs.

 - Requirement: RFC-6763
 */
public class TXTDecoder {

    // MARK: - Private
    private let storage: TXTDecodingStorage

    // MARK - Initializers

    /**
     Initializer

     - Parameters:
        - data: Data containing the contents of a DNS TXT record.
     */
    public init(from data: Data) throws
    {
        storage = TXTDecodingStorage(from: data)
    }

    init(storage: TXTDecodingStorage)
    {
        self.storage = storage
    }

    // MARK: - Containers

    public func container<Key>(keyedBy: Key.Type) -> TXTDecodingContainer<Key>
    {
        return TXTDecodingContainer(keyedBy: Key.self, storage: storage)
    }

}


// End of File
