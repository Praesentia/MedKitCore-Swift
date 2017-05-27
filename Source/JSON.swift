/*
-----------------------------------------------------------------------------
This source file is part of MedKitCore.
 
 Copyright 2016-2017 Jon Griffeth
 
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


import Foundation;


/**
 JSON
 
 - Remarks:
    Work in progress and rather crude.  I'd rather see something standardized
    as part of the Swift language.
 */
public class JSON {
    
    /**
     JSON Type
     */
    public enum JSONType {
        case any;
        case Array;
        case Bool;
        case Number;
        case int;
        case Null;
        case Object;
        case String;
    }
    
    // MARK: - Properties
    public var type   : JSONType         { return _type;      }
    public var array  : [JSON]?          { return _array;     }
    public var bool   : Bool?            { return _bool;      }
    public var double : Double?          { return toDouble(); }
    public var int    : Int?             { return toInt();    }
    public var number : Double?          { return toDouble(); }
    public var object : [String : JSON]? { return _object;    }
    public var string : String?          { return _string;    }
    public var time   : Int64?           { return toInt64();  }
    public var uuid   : UUID?            { return toUUID();   }

    // MARK: - Shadowed
    private var _type   : JSONType;
    private var _array  : [JSON]!;
    private var _bool   : Bool!;
    private var _int    : Int!;
    private var _double : Double!;
    private var _object : [String : JSON]!;
    private var _string : String!;
    
    /**
     */
    public init()
    {
        _type = .any;
    }
    
    /**
     */
    public init(_ value: [JSON])
    {
        _type  = .Array;
        _array = value;
    }
    
    /**
     */
    public init(_ value: Bool)
    {
        _type = .Bool;
        _bool = value;
    }
    
    /**
     */
    public init(_ value: Double)
    {
        _type   = .Number;
        _double = value;
    }
    
    /**
     */
    public init(_ value: Int)
    {
        _type = .int;
        _int  = value;
    }
    
    /**
     */
    public init(_ value: [String : JSON])
    {
        _type   = .Object;
        _object = value;
    }
    
    /**
     */
    public init(_ value: String)
    {
        _type   = .String;
        _string = value;
    }
    
    /**
     */
    public init(_ value: UUID)
    {
        _type   = .String;
        _string = value.uuidstring;
    }
    
    /**
     */
    public subscript(index: Int) -> JSON
    {
        get {
            cast(to: .Array);
            extend(to: index + 1);
            return _array[index];
        }
        set(value) {
            cast(to: .Array);
            extend(to: index + 1);
            _array[index] = value;
        }
    }
    
    public subscript(index: Int) -> UUID
    {
        get {
            cast(to: .Array);
            extend(to: index + 1);
            return UUID(uuidString: _array[index]._string!)!;
        }
        set(value) {
            cast(to: .Array);
            extend(to: index + 1);
            _array[index] = JSON(value);
        }
    }
    
    /*
    public subscript(index: Int) -> UUID?
    {
        get {
            cast(to: .Array);
            extend(to: index);
            if let value = _array[index]._string {
                return UUID(uuidString: value);
            }
            return nil;
        }
        set(value) {
            cast(to: .Array);
            extend(to: index);
            _array[index] = JSON(value!);
        }
    }
    */
    
    public subscript(key: String) -> JSON
    {
        get {
            cast(to: .Object);
            if let v = _object[key] {
                return v;
            }
            _object[key] = JSON();
            return _object[key]!;
        }
        set(value) {
            cast(to: .Object);
            _object[key] = value;
        }
    }
    
    public subscript(key: String) -> JSON?
    {
        get {
            return (type == .Object) ? _object[key] : nil;
        }
        set(value) {
            cast(to: .Object);
            _object[key] = value;
        }
    }
    
    public subscript(key: String) -> Bool
    {
        get {
            cast(to: .Object);
            return _object[key]!._bool!;
        }
        set(value) {
            cast(to: .Object);
            _object[key] = JSON(value);
        }
    }
    
    public subscript(key: String) -> Bool?
    {
        get {
            return (type == .Object) ? _object[key]?._bool : nil;
        }
        set(value) {
            cast(to: .Object);
            _object[key] = value != nil ? JSON(value!) : nil
        }
    }
    
    public subscript(key: String) -> Double
    {
        get {
            cast(to: .Object);
            return _object[key]!._double!;
        }
        set(value) {
            cast(to: .Object);
            _object[key] = JSON(value);
        }
    }
    
    public subscript(key: String) -> Double?
    {
        get {
            return (type == .Object) ? _object[key]?._double : nil;
        }
        set(value) {
            cast(to: .Object);
            _object[key] = value != nil ? JSON(value!) : nil
        }
    }
    
    public subscript(key: String) -> Int
    {
        get {
            cast(to: .Object);
            if let v = _object[key]!.toInt() {
                return v;
            }
            _object[key] = JSON();
            return _object[key]!.toInt()!;
        }
        set(value) {
            cast(to: .Object);
            _object[key] = JSON(value);
        }
    }
    
    public subscript(key: String) -> String
    {
        get {
            cast(to: .Object);
            return _object[key]!._string!;
        }
        set(value) {
            cast(to: .Object);
            _object[key] = JSON(value);
        }
    }
    
    public subscript(key: String) -> String?
    {
        get {
            return (type == .Object) ? _object[key]?._string : nil;
        }
        set(value) {
            cast(to: .Object);
            _object[key] = value != nil ? JSON(value!) : nil
        }
    }
    
    public subscript(key: String) -> UUID
    {
        get {
            cast(to: .Object);
            return UUID(uuidString: _object[key]!._string)!;
        }
        set(value) {
            cast(to: .Object);
            _object[key] = JSON(value);
        }
    }
    
    public subscript(key: String) -> UUID?
    {
        get {
            if type == .Object {
                if let string = _object[key]?.string {
                    return UUID(uuidString: string);
                }
            }
            return nil;
        }
        set(value) {
            cast(to: .Object);
            _object[key] = value != nil ? JSON(value!) : nil;
        }
    }
    
    public subscript(key: String) -> [JSON]
    {
        get {
            cast(to: .Object);
            return _object[key]!._array!;
        }
        set(value) {
            cast(to: .Object);
            _object[key] = JSON(value);
        }
    }
    
    /*
    public subscript(key: String) -> [JSON]?
    {
        get {
            cast(to: .Object);
            if let value = _object[key]?._array {
                return value;
            }
            return nil;
        }
        set(value) {
            cast(to: .Object);
            _object[key] = JSON(value!);
        }
    }
    */
    
    public func append(_ value: JSON)
    {
        cast(to: .Array);
        _array.append(value);
    }
    
    public func getCount() -> Int?
    {
        switch type {
        case .Array :
            return _array.count;
        
        case .Object :
            return _object.count;

        default :
            return nil;
        }
    }
    
    public func contains(key: String) -> Bool
    {
        return type == .Object && _object[key] != nil;
    }
    
    public func contains(key: String, type: JSONType) -> Bool
    {
        if type == .Object, let value = _object[key] {
            return value.type == type;
        }
        return false;
    }
    
    public func contains(_ path: [String]) -> Bool
    {
        var value = self;
        
        for key in path {
            if !value.contains(key: key) {
                return false;
            }
            value = value[key];
        }
        
        return true;
    }
    
    private func cast(to type: JSONType)
    {
        if _type == .any {
            switch type {
            case .any :
                break;
                
            case .Array:
                _array  = [JSON]();
            
            case .Bool:
                _bool   = Bool();
                
            case .Number:
                _double = Double();
                
            case .int:
                _int = Int();
                
            case .Null:
                break;
                
            case .Object:
                _object = [String : JSON]();
                
            case .String:
                _string = String();
            }
            
            _type = type;
        }
    }
    
    private func extend(to count: Int)
    {
        if _array != nil {
            if _array.count < count {
                for _ in _array.count..<count {
                    _array.append(JSON());
                }
            }
        }
    }
    
    private func force(to type: JSONType)
    {
        reset();
        cast(to: type);
    }
    
    private func reset()
    {
        switch _type {
        case .any :
            break;

        case .Array:
            _array  = nil;
            
        case .Bool:
            _bool   = nil;
            
        case .Number:
            _double = nil;
            
        case .int:
            _int    = nil;
            
        case .Null:
            break;
            
        case .Object:
            _object = nil;
            
        case .String:
            _string = nil;
        }
        
        _type = .any;
    }
    
    private func toDouble() -> Double?
    {
        switch type {
        case .int:
            if let value = _int {
                return Double(value);
            }
            return nil;
            
        case .Number:
            return _double;
            
        default:
            return nil;
        }
    }
    
    private func toInt() -> Int?
    {
        switch type {
        case .int:
            return _int;
            
        case .Number:
            if let value = _double {
                return Int(value);
            }
            return nil;
            
        default:
            return nil;
        }
    }
    
    private func toInt64() -> Int64?
    {
        switch type {
        case .int:
            if let value = _int {
                return Int64(value);
            }
            return nil;
            
        case .Number:
            if let value = _double {
                return Int64(value);
            }
            return nil;
            
        default:
            return nil;
        }
    }
    
    private func toUUID() -> UUID?
    {
        switch type {
        case .String:
            if let value = _string {
                return UUID(uuidString: value);
            }
            return nil;
            
        default:
            return nil;
        }
    }
    
}


// End of File
