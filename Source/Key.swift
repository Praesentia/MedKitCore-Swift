/*
 -----------------------------------------------------------------------------
 This source file is part of MedKitCore.
 
 Copyright 2017 Jon Griffeth
 
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
 */
public protocol Key: class {
    
    var blockSize : Int { get }
    
    /**
     Sign bytes for identity.
     
     Generate a signature for the specified bytes using the private credentials
     associated with identity.
     
     - Parameters:
        - bytes: The byte sequence to be signed.
     
     - Returns:
        Returns the signature as a sequence a bytes, or nil if the required
        credentials for identity do not exist.
     
     - Remarks:
        The bytes to be signed are often a hash
     */
    func sign(bytes: [UInt8]) -> [UInt8]
    
    /**
     Verify signature for identity.
     
     - Parameters:
        - signature: The signature to be verified.
        - bytes:     The byte sequence to be verified.
     */
    func verify(signature: [UInt8], for bytes: [UInt8]) -> Bool
    
    /**
     Verify signature for identity.
     
     - Parameters:
        - signature: The signature to be verified.
        - data:      The byte sequence to be verified.
     */
    func verify(signature: [UInt8], using digestType: DigestType, for data: Data) -> Bool
}


// End of File
