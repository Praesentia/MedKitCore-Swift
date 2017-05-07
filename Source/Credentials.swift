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


import Foundation;


/**
 Credentials protocol.
 
 A protocol to be implemented by various the forms of credentials.  The
 protocol presumes some type of signing and verification algorithm.
 
 The protocol provides access to a JSON profile reactivating the public
 component of the credentials.  This is the profile that is exchanged
 between entities during authentication.
 */
public protocol Credentials: class  {
    
    var profilePublic: JSON            { get } //: A JSON profile reactivating the public credentials.
    var type         : CredentialsType { get } //: Identifies the type of credentials.
    var expires      : TimeInterval?   { get }
    
    /**
     Sign bytes.
     
     - Parameters:
        - bytes: The bytes being signed.  This will typically be a hash value
            of the actual data.
     */
    func sign(bytes: [UInt8]) -> [UInt8]?;
    
    /**
     Verify signature
     
     - Parameters:
        - bytes: The bytes that were originally signed.  This will typically be
            a hash value of the actual data.
     */
    func verify(signature: [UInt8], bytes: [UInt8]) -> Bool;
}

public extension Credentials {
    
    func expired(at time: TimeInterval) -> Bool
    {
        if let expires = self.expires {
            return time >= expires;
        }
        return false;
    }
    
}


// End of File
