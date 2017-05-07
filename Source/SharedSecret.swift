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
 Shared secret credentials.
 */
public class SharedSecret: Credentials {
    
    public static let factory = SharedSecretFactory();
    
    public var profilePublic: JSON            { return getProfile(); }
    public var type         : CredentialsType { return .SharedSecret; }
    public var expires      : TimeInterval?   { return nil; }
    
    // MARK: - Private
    private let identity : Identity; //: The identity associated with the credentials.
    private let security = SecurityManagerShared.main;
    
    /**
     Initialize instance.
     */
    public init(for identity: Identity)
    {
        self.identity = identity;
    }
    
    /**
     Update secret.
     */
    public func updateSecret(_ secret: [UInt8], completionHandler completion: @escaping (Error?) -> Void)
    {
        security.internSecret(secret, for: identity, completionHandler: completion);
    }
    
    /**
     Sign bytes.
     
     - Parameters:
        - bytes: The bytes being signed.  This will typically be a hash value
            of the actual data.
     */
    public func sign(bytes: [UInt8]) -> [UInt8]?
    {
        return security.signBytes(bytes, for: identity, using: .SharedSecret);
    }
    
    /**
     Verify signature.
     
     - Parameters:
        - bytes: The bytes that were originally signed.  This will typically be
        a hash value of the actual data.
     */
    public func verify(signature: [UInt8], bytes: [UInt8]) -> Bool
    {
        return security.verifySignature(signature, for: identity, bytes: bytes, using: .SharedSecret);
    }
    
    /**
     Get profile.
     
     Generates a JSON profile reactivating the credentials.  In this case, the
     profile only includes the credentials type, as both sides are expected to
     know the secret.
     
     - Returns:
        Returns the generated JSON profile.
     */
    private func getProfile() -> JSON
    {
        let profile = JSON();
        
        profile[KeyType] = type.string;
        
        return profile;
    }
    
}


// End of File
