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


public class AnyDecoder {

    public var userInfo = [CodingUserInfoKey : Any]()

    public init()
    {
    }

    public func decode<T>(_ type: T.Type, from any: AnyCodable) throws -> T where T: Decodable
    {
        let decoder   = _AnyDecoder(from: any.value)
        let container = try decoder.singleValueContainer()

        return try container.decode(T.self)
    }

}

class _AnyDecoder: Decoder {

    // MARK: - Properties
    public private(set) var codingPath : [CodingKey]
    public private(set) var userInfo   : [CodingUserInfoKey : Any]

    // MARK: - Private
    let value: Any

    // MARK: - Initializers

    public init(from value: Any)
    {
        self.codingPath = []
        self.userInfo   = [:]
        self.value      = value
    }

    public init(codingPath: [CodingKey], from value: Any)
    {
        self.codingPath = codingPath
        self.userInfo   = [:]
        self.value      = value
    }

    // MARK: - Containers

    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey
    {
        guard let container = value as? [String : Any] else {
            throw DecodingError.typeMismatch([String : Any].self, DecodingError.Context(codingPath: codingPath, debugDescription: "Expected \([String : Any].self) value."))
        }

        return KeyedDecodingContainer(_KeyedDecodingContainer<Key>(codingPath: codingPath, container: container))
    }

    public func unkeyedContainer() throws -> UnkeyedDecodingContainer
    {
        guard let container = value as? [Any] else {
            throw DecodingError.typeMismatch([Any].self, DecodingError.Context(codingPath: codingPath, debugDescription: "Expected \([Any].self) value."))
        }

        return _UnkeyedDecodingContainer(codingPath: codingPath, container: container)
    }

    public func singleValueContainer() throws -> SingleValueDecodingContainer
    {
        return _SingleValueDecodingContainer(codingPath: codingPath, from: value)
    }

}

fileprivate class _DecoderBase {

    internal(set) var codingPath : [CodingKey]

    init(codingPath: [CodingKey])
    {
        self.codingPath = codingPath
    }

    func decodeNil(from value: Any) -> Bool
    {
        return (value as? NSNull) != nil
    }

    func decode(_ type: Bool.Type, from value: Any) throws -> Bool
    {
        guard let value = value as? Bool else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Expected \(type) value."))
        }

        return value
    }

    func decode(_ type: Int.Type, from value: Any) throws -> Int
    {
        guard let value = value as? Int else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Expected \(type) value."))
        }

        return value
    }

    func decode(_ type: Int8.Type, from value: Any) throws -> Int8
    {
        guard let value = value as? Int8 else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Expected \(type) value."))
        }

        return value
    }

    func decode(_ type: Int16.Type, from value: Any) throws -> Int16
    {
        guard let value = value as? Int16 else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Expected \(type) value."))
        }

        return value
    }

    func decode(_ type: Int32.Type, from value: Any) throws -> Int32
    {
        guard let value = value as? Int32 else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Expected \(type) value."))
        }

        return value
    }

    func decode(_ type: Int64.Type, from value: Any) throws -> Int64
    {
        guard let value = value as? Int64 else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Expected \(type) value."))
        }

        return value
    }

    func decode(_ type: UInt.Type, from value: Any) throws -> UInt
    {
        guard let value = value as? UInt else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Expected \(type) value."))
        }

        return value
    }

    func decode(_ type: UInt8.Type, from value: Any) throws -> UInt8
    {
        guard let value = value as? UInt8 else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Expected \(type) value."))
        }

        return value
    }

    func decode(_ type: UInt16.Type, from value: Any) throws -> UInt16
    {
        guard let value = value as? UInt16 else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Expected \(type) value."))
        }

        return value
    }

    func decode(_ type: UInt32.Type, from value: Any) throws -> UInt32
    {
        guard let value = value as? UInt32 else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Expected \(type) value."))
        }

        return value
    }

    func decode(_ type: UInt64.Type, from value: Any) throws -> UInt64
    {
        guard let value = value as? UInt64 else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Expected \(type) value."))
        }

        return value
    }

    func decode(_ type: Float.Type, from value: Any) throws -> Float
    {
        guard let value = value as? NSNumber else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Expected \(type) value."))
        }

        return Float(value.doubleValue)
    }

    func decode(_ type: Double.Type, from value: Any) throws -> Double
    {
        guard let value = value as? NSNumber else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Expected \(type) value."))
        }

        return value.doubleValue
    }

    func decode(_ type: String.Type, from value: Any) throws -> String
    {
        guard let value = value as? String else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Expected \(type) value."))
        }

        return value
    }

}

fileprivate class _KeyedDecodingContainer<K : CodingKey>: _DecoderBase, KeyedDecodingContainerProtocol {

    typealias Key = K

    // MARK: - Properties
    var allKeys: [K] { return container.keys.compactMap { Key(stringValue: $0) } }

    // MARK: - Private Properties
    private let container: [String : Any]

    // MARK: - Initializers

    init(codingPath: [CodingKey], container: [String : Any])
    {
        self.container = container
        super.init(codingPath: codingPath)
    }

    func contains(_ key: K) -> Bool
    {
        return container[key.stringValue] != nil
    }

    func decodeNil(forKey key: K) throws -> Bool
    {
        guard let value = self.container[key.stringValue] else {
            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath, debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\")."))
        }

        return decodeNil(from: value)
    }

    func decode(_ type: Bool.Type, forKey key: K) throws -> Bool
    {
        guard let value = self.container[key.stringValue] else {
            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath, debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\")."))
        }

        return try decode(Bool.self, from: value)
    }

    func decode(_ type: Int.Type, forKey key: K) throws -> Int
    {
        guard let value = self.container[key.stringValue] else {
            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath, debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\")."))
        }

        return try decode(Int.self, from: value)
    }

    func decode(_ type: Int8.Type, forKey key: K) throws -> Int8
    {
        guard let value = self.container[key.stringValue] else {
            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath, debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\")."))
        }

        return try decode(Int8.self, from: value)
    }

    func decode(_ type: Int16.Type, forKey key: K) throws -> Int16
    {
        guard let value = self.container[key.stringValue] else {
            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath, debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\")."))
        }

        return try decode(Int16.self, from: value)
    }

    func decode(_ type: Int32.Type, forKey key: K) throws -> Int32
    {
        guard let value = self.container[key.stringValue] else {
            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath, debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\")."))
        }

        return try decode(Int32.self, from: value)
    }

    func decode(_ type: Int64.Type, forKey key: K) throws -> Int64
    {
        guard let value = self.container[key.stringValue] else {
            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath, debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\")."))
        }

        return try decode(Int64.self, from: value)
    }

    func decode(_ type: UInt.Type, forKey key: K) throws -> UInt
    {
        guard let value = self.container[key.stringValue] else {
            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath, debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\")."))
        }

        return try decode(UInt.self, from: value)
    }

    func decode(_ type: UInt8.Type, forKey key: K) throws -> UInt8
    {
        guard let value = self.container[key.stringValue] else {
            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath, debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\")."))
        }

        return try decode(UInt8.self, from: value)
    }

    func decode(_ type: UInt16.Type, forKey key: K) throws -> UInt16
    {
        guard let value = self.container[key.stringValue] else {
            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath, debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\")."))
        }

        return try decode(UInt16.self, from: value)
    }

    func decode(_ type: UInt32.Type, forKey key: K) throws -> UInt32
    {
        guard let value = self.container[key.stringValue] else {
            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath, debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\")."))
        }

        return try decode(UInt32.self, from: value)
    }

    func decode(_ type: UInt64.Type, forKey key: K) throws -> UInt64
    {
        guard let value = self.container[key.stringValue] else {
            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath, debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\")."))
        }

        return try decode(UInt64.self, from: value)
    }

    func decode(_ type: Float.Type, forKey key: K) throws -> Float
    {
        guard let value = self.container[key.stringValue] else {
            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath, debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\")."))
        }

        return try decode(Float.self, from: value)
    }

    func decode(_ type: Double.Type, forKey key: K) throws -> Double
    {
        guard let value = self.container[key.stringValue] else {
            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath, debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\")."))
        }

        return try decode(Double.self, from: value)
    }

    func decode(_ type: String.Type, forKey key: K) throws -> String
    {
        guard let value = self.container[key.stringValue] else {
            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath, debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\")."))
        }

        return try decode(String.self, from: value)
    }

    func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T : Decodable
    {
        guard let value = self.container[key.stringValue] else {
            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath, debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\")."))
        }

        return try T(from: _AnyDecoder(codingPath: codingPath, from: value))
    }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: K) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey
    {
        guard let value = self.container[key.stringValue] else {
            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath, debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\")."))
        }

        guard let container = value as? [String : Any] else {
            throw DecodingError.typeMismatch([String : Any].self, DecodingError.Context(codingPath: codingPath, debugDescription: "Expected \([String : Any].self) value."))
        }

        return KeyedDecodingContainer(_KeyedDecodingContainer<NestedKey>(codingPath: codingPath, container: container))
    }

    func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer
    {
        guard let value = self.container[key.stringValue] else {
            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath, debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\")."))
        }

        guard let container = value as? [Any] else {
            throw DecodingError.typeMismatch([Any].self, DecodingError.Context(codingPath: codingPath, debugDescription: "Expected \([Any].self) value."))
        }

        return _UnkeyedDecodingContainer(codingPath: codingPath, container: container)
    }

    func superDecoder() throws -> Decoder
    {
        throw MedKitError.notImplemented
    }

    func superDecoder(forKey key: K) throws -> Decoder
    {
        throw MedKitError.notImplemented
    }

}

fileprivate class _UnkeyedDecodingContainer: _DecoderBase, UnkeyedDecodingContainer {

    var              count        : Int? { return container.count }
    var              isAtEnd      : Bool { return currentIndex >= container.count }
    private(set) var currentIndex : Int = 0

    // MARK: Private Properties
    private let container: [Any]

    init(codingPath: [CodingKey], container: [Any])
    {
        self.container = container
        super.init(codingPath: codingPath)
    }

    func decodeNil() throws -> Bool
    {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(Any?.self, DecodingError.Context(codingPath: codingPath, debugDescription: "Unkeyed container is at end."))
        }

        let value = decodeNil(from: container[currentIndex])
        if value {
            currentIndex += 1
        }

        return value
    }

    func decode(_ type: Bool.Type) throws -> Bool
    {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Unkeyed container is at end."))
        }

        let value = try decode(Bool.self, from: container[currentIndex])
        currentIndex += 1

        return value
    }

    func decode(_ type: Int.Type) throws -> Int
    {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Unkeyed container is at end."))
        }

        let value = try decode(Int.self, from: container[currentIndex])
        currentIndex += 1

        return value
    }

    func decode(_ type: Int8.Type) throws -> Int8
    {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Unkeyed container is at end."))
        }

        let value = try decode(Int8.self, from: container[currentIndex])
        currentIndex += 1

        return value
    }

    func decode(_ type: Int16.Type) throws -> Int16
    {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Unkeyed container is at end."))
        }

        let value = try decode(Int16.self, from: container[currentIndex])
        currentIndex += 1

        return value
    }

    func decode(_ type: Int32.Type) throws -> Int32
    {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Unkeyed container is at end."))
        }

        let value = try decode(Int32.self, from: container[currentIndex])
        currentIndex += 1

        return value
    }

    func decode(_ type: Int64.Type) throws -> Int64
    {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Unkeyed container is at end."))
        }

        let value = try decode(Int64.self, from: container[currentIndex])
        currentIndex += 1

        return value
    }

    func decode(_ type: UInt.Type) throws -> UInt
    {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Unkeyed container is at end."))
        }

        let value = try decode(UInt.self, from: container[currentIndex])
        currentIndex += 1

        return value
    }

    func decode(_ type: UInt8.Type) throws -> UInt8
    {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Unkeyed container is at end."))
        }

        let value = try decode(UInt8.self, from: container[currentIndex])
        currentIndex += 1

        return value
    }

    func decode(_ type: UInt16.Type) throws -> UInt16
    {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Unkeyed container is at end."))
        }

        let value = try decode(UInt16.self, from: container[currentIndex])
        currentIndex += 1

        return value
    }

    func decode(_ type: UInt32.Type) throws -> UInt32
    {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Unkeyed container is at end."))
        }

        let value = try decode(UInt32.self, from: container[currentIndex])
        currentIndex += 1

        return value
    }

    func decode(_ type: UInt64.Type) throws -> UInt64
    {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Unkeyed container is at end."))
        }

        let value = try decode(UInt64.self, from: container[currentIndex])
        currentIndex += 1

        return value
    }

    func decode(_ type: Float.Type) throws -> Float
    {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Unkeyed container is at end."))
        }

        let value = try decode(Float.self, from: container[currentIndex])
        currentIndex += 1

        return value
    }

    func decode(_ type: Double.Type) throws -> Double
    {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Unkeyed container is at end."))
        }

        let value = try decode(Double.self, from: container[currentIndex])
        currentIndex += 1

        return value
    }

    func decode(_ type: String.Type) throws -> String
    {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Unkeyed container is at end."))
        }

        let value = try decode(String.self, from: container[currentIndex])
        currentIndex += 1

        return value
    }

    func decode<T>(_ type: T.Type) throws -> T where T : Decodable
    {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Unkeyed container is at end."))
        }

        let value = try T(from: _AnyDecoder(codingPath: codingPath, from: container[currentIndex]))
        currentIndex += 1

        return value
    }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey
    {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound([String : Any].self, DecodingError.Context(codingPath: codingPath, debugDescription: "Unkeyed container is at end."))
        }

        guard let container = container[currentIndex] as? [String : Any] else {
            throw DecodingError.typeMismatch([String : Any].self, DecodingError.Context(codingPath: codingPath, debugDescription: "Expected \([String : Any].self) value."))
        }

        currentIndex += 1

        return KeyedDecodingContainer(_KeyedDecodingContainer<NestedKey>(codingPath: codingPath, container: container))
    }

    func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer
    {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound([Any].self, DecodingError.Context(codingPath: codingPath, debugDescription: "Unkeyed container is at end."))
        }

        guard let container = container[currentIndex] as? [Any] else {
            throw DecodingError.typeMismatch([Any].self, DecodingError.Context(codingPath: codingPath, debugDescription: "Expected \([Any].self) value."))
        }

        currentIndex += 1

        return _UnkeyedDecodingContainer(codingPath: codingPath, container: container)
    }

    func superDecoder() throws -> Decoder
    {
        throw MedKitError.notImplemented
    }


}

fileprivate class _SingleValueDecodingContainer: _DecoderBase, SingleValueDecodingContainer {

    // MARK: - Private Properties
    private let value: Any

    // MARK: - Initializers

    init(codingPath: [CodingKey], from value: Any)
    {
        self.value = value
        super.init(codingPath: codingPath)
    }

    // MARK: - Decoding

    func decodeNil() -> Bool
    {
        return decodeNil(from: value)
    }

    func decode(_ type: Bool.Type) throws -> Bool
    {
        return try decode(Bool.self, from: value)
    }

    func decode(_ type: Int.Type) throws -> Int
    {
        return try decode(Int.self, from: value)
    }

    func decode(_ type: Int8.Type) throws -> Int8
    {
        return try decode(Int8.self, from: value)
    }

    func decode(_ type: Int16.Type) throws -> Int16
    {
        return try decode(Int16.self, from: value)
    }

    func decode(_ type: Int32.Type) throws -> Int32
    {
        return try decode(Int32.self, from: value)
    }

    func decode(_ type: Int64.Type) throws -> Int64
    {
        return try decode(Int64.self, from: value)
    }

    func decode(_ type: UInt.Type) throws -> UInt
    {
        return try decode(UInt.self, from: value)
    }

    func decode(_ type: UInt8.Type) throws -> UInt8
    {
        return try decode(UInt8.self, from: value)
    }

    func decode(_ type: UInt16.Type) throws -> UInt16
    {
        return try decode(UInt16.self, from: value)
    }

    func decode(_ type: UInt32.Type) throws -> UInt32
    {
        return try decode(UInt32.self, from: value)
    }

    func decode(_ type: UInt64.Type) throws -> UInt64
    {
        return try decode(UInt64.self, from: value)
    }

    func decode(_ type: Float.Type) throws -> Float
    {
        return try decode(Float.self, from: value)
    }

    func decode(_ type: Double.Type) throws -> Double
    {
        return try decode(Double.self, from: value)
    }

    func decode(_ type: String.Type) throws -> String
    {
        return try decode(String.self, from: value)
    }

    func decode<T>(_ type: T.Type) throws -> T where T : Decodable
    {
        return try T(from: _AnyDecoder(codingPath: codingPath, from: value))
    }

}


// End of File


