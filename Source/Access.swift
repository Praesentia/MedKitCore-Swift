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


import Foundation


public enum Access: Int {
    case readOnly  = 1
    case writeOnly = 2
    case readWrite = 3
}

public extension Access {
    
    public init?(string: String)
    {
        switch string {
        case "ReadOnly" :
            self = .readOnly
            
        case "WriteOnly" :
            self = .writeOnly
            
        case "ReadWrite" :
            self = .readWrite
            
        default :
            return nil
        }
    }
    
    public var string: String {
        switch self {
        case .readOnly :
            return "ReadOnly"
            
        case .writeOnly :
            return "WriteOnly"
            
        case .readWrite :
            return "ReadWrite"
        }
    }
    
}


// End of File
