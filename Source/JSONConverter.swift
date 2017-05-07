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
 JSON Converter
 */
public class JSONConverter {
    
    public class func externalize(json: JSON) -> Any?
    {
        switch json.type {
        case .any :
            return nil;
        
        case .Array :
            var array = [Any]();
            
            for value in json.array! {
                array.append(externalize(json: value) ?? NSNull());
            }
            return array;
        
        case .Bool :
            return json.bool!;

        case .Number :
            return json.number!;
            
        case .int :
            return json.int!;
            
        case .Null :
            return NSNull();
            
        case .Object :
            var object = [String : Any]();
            
            for (key, value) in json.object! {
                object[key] = externalize(json: value);
            }
            return object;
        
        case .String :
            return json.string!;
        }
    }
    
    class func convert(_ value: Any) -> JSON
    {
        switch value {
        case let v as [Any]:
            return convertArray(v);
            
        case let v as Double:
            return JSON(v);
            
        case let v as Int:
            return JSON(v);
        
        case let v as Bool:
            return JSON(v);
            
        case is NSNull:
            return JSON();
            
        case let v as [String : Any]:
            return convertObject(v);
        
        case let v as String:
            return JSON(v);
            
        default :
            fatalError("Unsupported Type");
        }
    }
    
    private class func convertArray(_ values: [Any]) -> JSON
    {
        var array = [JSON]();
        
        for value in values {
            array.append(convert(value));
        }
        
        return JSON(array);
    }
    
    private class func convertObject(_ pairs: [String : Any]) -> JSON
    {
        var dictionary = [String : JSON]();
        
        for (key, value) in pairs {
            dictionary[key] = convert(value);
        }
        
        return JSON(dictionary);
    }
    
}


// End of File
