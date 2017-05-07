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
 Null credentials.
 */
public class NullCredentials: Credentials {
    
    public static let instance = NullCredentials();

    public var profilePublic: JSON            { return getProfile(); }
    public var type         : CredentialsType { return .Null; }
    public var expires      : TimeInterval?   { return nil; }
    
    /**
     Initialize instance.
     */
    private init()
    {
    }
    
    /**
     Sign bytes.
     
     - Parameters:
     - bytes: The bytes being signed.  This will typically be a hash value
     of the actual data.
     */
    public func sign(bytes: [UInt8]) -> [UInt8]?
    {
        return nil;
    }
    
    /**
     Verify signature
     
     - Parameters:
        - bytes: The bytes that were originally signed.  This will typically be
            a hash value of the actual data.
     */
    public func verify(signature: [UInt8], bytes: [UInt8]) -> Bool
    {
        return false;
    }
    
    private func getProfile() -> JSON
    {
        let profile = JSON();
        
        profile[KeyType] = type.string;
        
        return profile;
    }
    
}


// End of File
