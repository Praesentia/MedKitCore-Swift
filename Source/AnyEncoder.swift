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


public class AnyEncoder {

    public var userInfo: [CodingUserInfoKey : Any]

    public init()
    {
        userInfo = [CodingUserInfoKey : Any]()
    }

    public func encode(_ value: Encodable) throws -> AnyCodable
    {
        let encoder = _AnyEncoder(codingPath: [])

        try value.encode(to: encoder)
        return AnyCodable(encoder.value)
    }

}

class _AnyEncoder: Encoder {

    // MARK: - Properties
    private(set) var  codingPath : [CodingKey]
    var               userInfo   : [CodingUserInfoKey : Any]
    var               value      : Any { return container.value }

    // MARK: - Private
    var container: AnyContainer!

    init(codingPath: [CodingKey])
    {
        self.codingPath = codingPath
        self.userInfo   = [:]
        self.container  = nil
    }

    // MARK: - Encoder

    public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey
    {
        let dictionary = NSMutableDictionary()
        let container = _KeyedEncodingContainer<Key>(codingPath: codingPath, container: dictionary)

        self.container = container
        return KeyedEncodingContainer(container)
    }

    public func unkeyedContainer() -> UnkeyedEncodingContainer
    {
        let array     = NSMutableArray()
        let container = _UnkeyedEncodingContainer(codingPath: codingPath, container: array)

        self.container = container
        return container
    }

    public func singleValueContainer() -> SingleValueEncodingContainer
    {
        let container = _SingleValueEncodingContainer(codingPath: codingPath)

        self.container = container
        return container
    }

    func encodeAny(_ value: Any)
    {
        self.container = _SingleValueEncodingContainer(codingPath: codingPath, value: value)
    }

}

fileprivate class _KeyedEncodingContainer<K : CodingKey>: AnyContainer, KeyedEncodingContainerProtocol {

    // MARK: - Properties
    typealias Key = K

    let codingPath : [CodingKey]
    var count      : Int { return container.count }
    var value      : Any { return container }

    // MARK: - Private
    private let container: NSMutableDictionary

    // MARK: - Initializers

    init(codingPath: [CodingKey], container: NSMutableDictionary)
    {
        self.codingPath = codingPath
        self.container  = container
    }

    // MARK: - KeyedEncodingContainerProtocol

    func encodeNil(forKey key: Key) throws
    {
        container[key.stringValue] = NSNull()
    }

    func encode(_ value: Bool, forKey key: Key) throws
    {
        container[key.stringValue] = NSNumber(value: value)
    }

    func encode(_ value: Int, forKey key: Key) throws
    {
        container[key.stringValue] = NSNumber(value: value)
    }

    func encode(_ value: Int8, forKey key: Key) throws
    {
        container[key.stringValue] = NSNumber(value: value)
    }

    func encode(_ value: Int16, forKey key: Key) throws
    {
        container[key.stringValue] = NSNumber(value: value)
    }

    func encode(_ value: Int32, forKey key: Key) throws
    {
        container[key.stringValue] = NSNumber(value: value)
    }

    func encode(_ value: Int64, forKey key: Key) throws
    {
        container[key.stringValue] = NSNumber(value: value)
    }

    func encode(_ value: UInt, forKey key: Key) throws
    {
        container[key.stringValue] = NSNumber(value: value)
    }

    func encode(_ value: UInt8, forKey key: Key) throws
    {
        container[key.stringValue] = NSNumber(value: value)
    }

    func encode(_ value: UInt16, forKey key: Key) throws
    {
        container[key.stringValue] = NSNumber(value: value)
    }

    func encode(_ value: UInt32, forKey key: Key) throws
    {
       container[key.stringValue] = NSNumber(value: value)
    }

    func encode(_ value: UInt64, forKey key: Key) throws
    {
        container[key.stringValue] = NSNumber(value: value)
    }

    func encode(_ value: Float, forKey key: Key) throws
    {
        container[key.stringValue] = NSNumber(value: value)
    }

    func encode(_ value: Double, forKey key: Key) throws
    {
        container[key.stringValue] = NSNumber(value: value)
    }

    func encode(_ value: String, forKey key: Key) throws
    {
        container[key.stringValue] = NSString(string: value)
    }

    func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable
    {
        let encoder = _AnyEncoder(codingPath: codingPath)

        try value.encode(to: encoder)
        container[key.stringValue] = encoder.value
    }

    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey
    {
        let dictionary = NSMutableDictionary()

        container[key.stringValue] = dictionary
        return KeyedEncodingContainer<NestedKey>(_KeyedEncodingContainer<NestedKey>(codingPath: codingPath, container: dictionary))
    }

    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer
    {
        let array = NSMutableArray()

        container[key.stringValue] = array
        return _UnkeyedEncodingContainer(codingPath: codingPath, container: array)
    }

    func superEncoder() -> Encoder
    {
        fatalError("Unimplemented")
    }

    func superEncoder(forKey key: Key) -> Encoder
    {
        fatalError("Unimplemented")
    }

}

fileprivate class _UnkeyedEncodingContainer: AnyContainer, UnkeyedEncodingContainer {

    let codingPath : [CodingKey]
    var count      : Int { return container.count }
    var value      : Any { return container }

    // MARK: - Private
    private let container: NSMutableArray

    // MARK: - Initializers

    init(codingPath: [CodingKey], container: NSMutableArray)
    {
        self.codingPath = codingPath
        self.container  = container
    }

    // MARK: - Encoding

    func encodeNil() throws
    {
        container.add(NSNull())
    }

    func encode(_ value: Bool) throws
    {
        container.add(NSNumber(value: value))
    }

    func encode(_ value: Int) throws
    {
        container.add(NSNumber(value: value))
    }

    func encode(_ value: Int8) throws
    {
        container.add(NSNumber(value: value))
    }

    func encode(_ value: Int16) throws
    {
        container.add(NSNumber(value: value))
    }

    func encode(_ value: Int32) throws
    {
        container.add(NSNumber(value: value))
    }

    func encode(_ value: Int64) throws
    {
        container.add(NSNumber(value: value))
    }

    func encode(_ value: UInt) throws
    {
        container.add(NSNumber(value: value))
    }

    func encode(_ value: UInt8) throws
    {
        container.add(NSNumber(value: value))
    }

    func encode(_ value: UInt16) throws
    {
        container.add(NSNumber(value: value))
    }

    func encode(_ value: UInt32) throws
    {
        container.add(NSNumber(value: value))
    }

    func encode(_ value: UInt64) throws
    {
        container.add(NSNumber(value: value))
    }

    func encode(_ value: Float) throws
    {
        container.add(NSNumber(value: value))
    }

    func encode(_ value: Double) throws
    {
        container.add(NSNumber(value: value))
    }

    func encode(_ value: String) throws
    {
        container.add(NSString(string: value))
    }

    func encode<T>(_ value: T) throws where T : Encodable
    {
        let encoder = _AnyEncoder(codingPath: codingPath)

        try value.encode(to: encoder)
        container.add(encoder.value)
    }

    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey
    {
        let dictionary = NSMutableDictionary()

        container.add(dictionary)
        return KeyedEncodingContainer<NestedKey>(_KeyedEncodingContainer<NestedKey>(codingPath: codingPath, container: dictionary))
    }

    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer
    {
        let array = NSMutableArray()

        container.add(array)
        return _UnkeyedEncodingContainer(codingPath: codingPath, container: array)
    }

    func superEncoder() -> Encoder
    {
        fatalError("Unimplemented")
    }

}

/**
 Single value encoding container.
 */
class _SingleValueEncodingContainer: AnyContainer, SingleValueEncodingContainer {

    // MARK: - Properties
    let codingPath : [CodingKey]
    var value      : Any { return container! }

    // MARK: - Private
    private var container: Any?

    // MARK: - Initializers

    init(codingPath: [CodingKey], value: Any? = nil)
    {
        self.codingPath = codingPath
        self.container  = value
    }

    private func set(_ value: Any) throws
    {
        guard self.container == nil else {
            throw DecodingError.valueNotFound([Any].self, DecodingError.Context(codingPath: codingPath, debugDescription: "Value already set."))
        }

        self.container = value
    }

    // MARK: - Decoding

    func encodeNil() throws
    {
        try set(NSNull())
    }

    func encode(_ value: Bool) throws
    {
        try set(NSNumber(value: value))
    }

    func encode(_ value: Int) throws
    {
        try set(NSNumber(value: value))
    }

    func encode(_ value: Int8) throws
    {
        try set(NSNumber(value: value))
    }

    func encode(_ value: Int16) throws
    {
        try set(NSNumber(value: value))
    }

    func encode(_ value: Int32) throws
    {
        try set(NSNumber(value: value))
    }

    func encode(_ value: Int64) throws
    {
        try set(NSNumber(value: value))
    }

    func encode(_ value: UInt) throws
    {
        try set(NSNumber(value: value))
    }

    func encode(_ value: UInt8) throws
    {
        try set(NSNumber(value: value))
    }

    func encode(_ value: UInt16) throws
    {
        try set(NSNumber(value: value))
    }

    func encode(_ value: UInt32) throws
    {
        try set(NSNumber(value: value))
    }

    func encode(_ value: UInt64) throws
    {
        try set(NSNumber(value: value))
    }

    func encode(_ value: Float) throws
    {
        try set(NSNumber(value: value))
    }

    func encode(_ value: Double) throws
    {
        try set(NSNumber(value: value))
    }

    func encode(_ value: String) throws
    {
        try set(NSString(string: value))
    }

    func encode<T>(_ value: T) throws where T: Encodable
    {
        let encoder = _AnyEncoder(codingPath: codingPath)

        try value.encode(to: encoder)
        try set(encoder.value)
    }

    func encodeAny(_ value: Any) throws
    {
        try set(value)
    }

}


// End of File
