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
 Public Key certificate.
 */
public class Certificate {
    
    public var chain  : [Data] { return _chain; }
    public var profile: JSON   { return getProfile(); }
    
    // MARK: - Shadowed
    private let _chain: [Data];
    
    /**
     Initialize instance.
     
     - Parameters:
        - chain: The certificate chains for the
     */
    public init(chain: [Data])
    {
        _chain = chain;
    }
    
    public func verify(for identity: Identity) -> Bool
    {
        return SecurityManagerShared.main.verify(certificate: self, for: identity);
    }
    
    public func verifySignature(_ signature: [UInt8], bytes: [UInt8]) -> Bool
    {
        return SecurityManagerShared.main.verifySignature(signature, for: self, bytes: bytes);
    }
    
    private func getProfile() -> JSON
    {
        return JSON(chain.map() { data in JSON(data.base64EncodedString()); });
    }
    
}


// End of File
