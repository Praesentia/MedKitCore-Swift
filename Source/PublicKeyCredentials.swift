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
 Public Key credentials.
 
 - remark
    - Placeholder (not implemented).
 */
public class PublicKeyCredentials: Credentials {
    
    public static let factory = PublicKeyCredentialsFactory();
    
    public var profilePublic: JSON            { return getProfile(); }
    public var type         : CredentialsType { return .PublicKey; }
    public var expires      : TimeInterval?   { return nil; }
    
    private let security    = SecurityManagerShared.main;

    private let identity    : Identity; //: The identity associated with the credentials.
    private var certificate : Certificate?;
    
    /**
     Initialize instance.
     */
    public init(for identity: Identity)
    {
        self.identity    = identity;
        self.certificate = security.getCertificate(for: identity);
    }
    
    /**
     Initialize instance.
     */
    public init(from profile: JSON, for identity: Identity)
    {
        var chain = [Data]();
        
        self.identity = identity;
        
        if let array = profile[KeyCertificateChain].array {
            for string in array {
                chain.append(Data(base64Encoded: string.string!)!);
            }
            
            self.certificate = Certificate(chain: chain);
        }
    }
    
    /**b
     Sign bytes.
     
     - Parameters:
        - bytes: The bytes being signed.  This will typically be a hash value
            of the actual data.
     */
    public func sign(bytes: [UInt8]) -> [UInt8]?
    {
        return security.signBytes(bytes, for: identity, using: .PublicKey);
    }
    
    /**
     Verify signature.
     
     - Parameters:
        - bytes: The bytes that were originally signed.  This will typically be
            a hash value of the actual data.
     */
    public func verify(signature: [UInt8], bytes: [UInt8]) -> Bool
    {
        if let certificate = self.certificate {
            return certificate.verify(for: identity) && certificate.verifySignature(signature, bytes: bytes);
        }
        return security.verifySignature(signature, for: identity, bytes: bytes, using: .PublicKey);
    }
    
    /**
     Get profile.
     
     Generates a JSON profile reactivating the credentials.
     
     - Returns:
        Returns the generated JSON profile.
     */
    private func getProfile() -> JSON
    {
        let profile = JSON();
        
        profile[KeyType]             = type.string;
        profile[KeyCertificateChain] = certificate!.profile;
        
        return profile;
    }
    
}


// End of File
