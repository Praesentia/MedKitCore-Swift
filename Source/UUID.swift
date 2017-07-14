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


private let UUID_LENGTH = Int(16)


public extension UUID {
    
    /**
     Null UUID, consisting entirely of zero bytes.
     */
    static let null = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
    
    /**
     */
    init(uuidBytes bytes: [UInt8])
    {
        self.init(uuidString: NSUUID(uuidBytes: bytes).uuidString)! // TODO: is there a better way?
    }
    
    /**
     Type 5 UUID
     
     Constructs a type 5 UUID using the output from the SHA1 algorithm.
     
     - Parameters:
        - digest: The output from the SHA1 hash algorithm.  Only the first 16
            bytes are used.
     */
    init(fromSHA1 digest: [UInt8])
    {
        var data = Array<UInt8>(digest[0..<UUID_LENGTH])
        
        data[6] = data[6] & 0x0f | 0x50
        data[8] = data[8] & 0x3f | 0x80
        
        self.init(uuidBytes: data)
    }
    
    /**
     String representation.
     
     A lowercase version of uuidString.
     
     - Remark:
        RFC 4122 specifies lowercase.
     */
    var uuidstring: String
    {
        return uuidString.lowercased()
    }

}


// End of File
