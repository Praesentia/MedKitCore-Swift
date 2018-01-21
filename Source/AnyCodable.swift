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
 The AnyCodable class provides a flexible interface for processing arbitrary
 codable data structures.
 */
public class AnyCodable: Codable {

    // MARK: - Properties
    public var decoder: Decoder { return _AnyDecoder(from: value) }

    // MARK: - Internal
    let value: Any

    // MARK: - Initializers

    public init(_ value: Any = NSNull())
    {
        self.value = value
    }

    public init(_ encodable: Encodable) throws
    {
        self.value = try AnyEncoder().encode(encodable).value
    }

    // MARK: - Decoding

    public func decode<T: Decodable>(_ type: T.Type) throws -> T
    {
        return try AnyDecoder().decode(T.self, from: self)
    }

    // MARK: - Codable

    required public init(from decoder: Decoder) throws
    {
        if let decoder = decoder as? _AnyDecoder {
            self.value = decoder.value
        }
        else if let container = try? decoder.container(keyedBy: AnyCodableCodingKeys.self) {
            self.value = try AnyCodable.decode(from: container)
        }
        else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: ""))
        }
    }

    public func encode(to encoder: Encoder) throws
    {
        if let encoder = encoder as? _AnyEncoder {
            encoder.encodeAny(value) // shortcut
        }
        else {
            switch value {
            case let dictionary as [String : Any] :
                var container = encoder.container(keyedBy: AnyCodableCodingKeys.self)
                try encode(dictionary, to: &container)

            case let array as [Any] :
                var container = encoder.unkeyedContainer()
                try encode(array, to: &container)

            default :
                var container = encoder.singleValueContainer()
                try encode(value, to: &container)
            }
        }
    }

    // MARK: - Private

    private enum ValueType {
        case array
        case bool
        case dictionary
        case double
        case int
        case null
        case string
    }

    private func getValueType(_ value: Any) throws -> ValueType
    {
        if (value is NSNull)
        {
            return .null
        }
        if isBool(value)
        {
            return .bool
        }
        if isInt(value)
        {
            return .int
        }
        if isDouble(value)
        {
            return .double
        }
        if isString(value)
        {
            return .string
        }
        if isDictionary(value)
        {
            return .dictionary
        }
        if isArray(value)
        {
            return .array
        }

        throw MedKitError.failed
    }

    private func isArray(_ value: Any) -> Bool
    {
        var result: Bool = false

        if let _ = value as? [Any] {
            result = true
        }

        return result
    }

    private func isBool(_ value: Any) -> Bool
    {
        var result: Bool = false

        if let number = value as? NSNumber {
            result = (number === (kCFBooleanTrue as NSNumber)) || (number === (kCFBooleanFalse as NSNumber))
        }

        return result
    }

    private func isInt(_ value: Any) -> Bool
    {
        var result: Bool = false

        if let number = value as? NSNumber {
            result = NSNumber(value: number.intValue) == number
        }

        return result
    }

    private func isDictionary(_ value: Any) -> Bool
    {
        var result: Bool = false

        if let _ = value as? [String : Any] {
            result = true
        }

        return result
    }

    private func isDouble(_ value: Any) -> Bool
    {
        var result: Bool = false

        if let number = value as? NSNumber {
            result = NSNumber(value: number.doubleValue) == number
        }

        return result
    }

    private func isString(_ value: Any) -> Bool
    {
        var result: Bool = false

        if let _ = value as? String {
            result = true
        }

        return result
    }

    private func encode(_ dictionary: [String : Any], to container: inout KeyedEncodingContainer<AnyCodableCodingKeys>) throws
    {
        for (string, value) in dictionary {
            let key = AnyCodableCodingKeys(string)

            switch try getValueType(value) {
            case .array :
                var nestedContainer = container.nestedUnkeyedContainer(forKey: key)
                try encode(value as! [Any], to: &nestedContainer)

            case .bool :
                try container.encode(value as! Bool, forKey: key)

            case .dictionary :
                var nestedContainer = container.nestedContainer(keyedBy: AnyCodableCodingKeys.self, forKey: key)
                try encode(value as! [String : Any], to: &nestedContainer)

            case .double :
                try container.encode(value as! Double, forKey: key)

            case .int :
                try container.encode(value as! Int, forKey: key)

            case .null :
                try container.encodeNil(forKey: key)

            case .string :
                try container.encode(value as! String, forKey: key)
            }
        }
    }

    private func encode(_ array: [Any], to container: inout UnkeyedEncodingContainer) throws
    {
        for value in array {
            switch try getValueType(value) {
            case .array :
                var nestedContainer = container.nestedUnkeyedContainer()
                try encode(value as! [Any], to: &nestedContainer)

            case .bool :
                try container.encode(value as! Bool)

            case .dictionary :
                var nestedContainer = container.nestedContainer(keyedBy: AnyCodableCodingKeys.self)
                try encode(value as! [String : Any], to: &nestedContainer)

            case .double :
                try container.encode(value as! Double)

            case .int :
                try container.encode(value as! Int)

            case .null :
                try container.encodeNil()

            case .string :
                try container.encode(value as! String)
            }
        }
    }

    private func encode(_ value: Any, to container: inout SingleValueEncodingContainer) throws
    {
        switch try getValueType(value) {
        case .null :
            try container.encodeNil()

        case .bool :
            try container.encode(value as! Bool)

        case .double :
            try container.encode(value as! Double)

        case .int :
            try container.encode(value as! Int)

        case .string :
            try container.encode(value as! String)

        default :
            break
        }
    }

    private static func decode(from container: KeyedDecodingContainer<AnyCodableCodingKeys>) throws -> [String : Any]
    {
        var dictionary = [String : Any]()

        for key in container.allKeys {
            if try container.decodeNil(forKey: key) {
                dictionary[key.stringValue] = NSNull()
            }
            else if let value = try? container.decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = NSNumber(value: value)
            }
            else if let value = try? container.decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = NSNumber(value: value)
            }
            else if let value = try? container.decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = NSNumber(value: value)
            }
            else if let value = try? container.decode(String.self, forKey: key) {
                dictionary[key.stringValue] = NSString(string: value)
            }
            else if let nestedContainer = try? container.nestedContainer(keyedBy: AnyCodableCodingKeys.self, forKey: key) {
                dictionary[key.stringValue] = try decode(from: nestedContainer)
            }
            else if var nestedContainer = try? container.nestedUnkeyedContainer(forKey: key) {
                dictionary[key.stringValue] = try decode(from: &nestedContainer)
            }
            else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: ""))
            }
        }

        return dictionary
    }

    private static func decode(from container: inout UnkeyedDecodingContainer) throws -> [Any]
    {
        var array = [Any]()

        while !container.isAtEnd {
            if try container.decodeNil() {
                array.append(NSNull())
            }
            else if let value = try? container.decode(Bool.self) {
                array.append(NSNumber(value: value))
            }
            else if let value = try? container.decode(Int.self) {
                array.append(NSNumber(value: value))
            }
            else if let value = try? container.decode(Double.self) {
                array.append(NSNumber(value: value))
            }
            else if let value = try? container.decode(String.self) {
                array.append(NSString(string: value))
            }
            else if let nestedContainer = try? container.nestedContainer(keyedBy: AnyCodableCodingKeys.self) {
                array.append(try decode(from: nestedContainer))
            }
            else if var nestedContainer = try? container.nestedUnkeyedContainer() {
                array.append(try decode(from: &nestedContainer))
            }
            else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: ""))
            }
        }

        return array
    }

}


// End of File
