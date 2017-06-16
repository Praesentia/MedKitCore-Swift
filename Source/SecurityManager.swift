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


public typealias SecKeyType = UUID;
public let SecKeyRoot           = UUID(uuidString: "9c9dacb6-14f4-426a-8bb7-a7037ea1b204")!;
public let SecKeyAuthentication = UUID(uuidString: "5c88ea5b-a058-4d6a-a2dc-10747f7f3953")!;


/**
 SecurityManager protocol.
 
 Functionally, the protocol follows a security enclave model such that private
 keys are never passed out of the interface.   All cryptographic operations
 involving these keys must be performed within the enclave.
 
 only one type of credentials can be associated for each identity...
 
 - Remarks:
    The interface is somewhat primitive at the moment.
    Only one of each type of credential can be associated with an identity.
 */
public protocol SecurityManager: class {
    
    var identities : [Identity] { get };
    
    // MARK: - Credentials
    
    func createCredentials(for identity: Identity) -> Credentials?;
    
    func createSharedSecretCredentials(for identity: Identity, with secret: [UInt8], completionHandler completion: @escaping (Error?, Credentials?) -> Void);
    
    /**
     Get credentials for identity.
     
     - Parameters:
        - identity: Identifies the principal.
     
     - Returns:
        Returns the credentials for identity, or nil if the credentials do not
        exist.
     */
    func getCredentials(for identity: Identity, using type: CredentialsType) -> Credentials?;
    
    func getCredentials(for identity: Identity, from profile: JSON) -> Credentials?
    
    func loadSharedSecretCredentials(for identity: Identity) -> Credentials?;
    
    func loadPublicCredentials(for identity: Identity, from data: Data) -> Credentials?;
    
    func loadCredentials(fromPKCS12 data: Data, with password: String) -> Credentials?;
    
    // MARK: - Digest
    
    func digest(using algorithm: DigestType) -> Digest;
    
    // MARK: - Random
    
    /**
     Generate random bytes.
     
     Generates an array of random bytes.
     
     - Parameters:
        - count: Size of the returned array.
     
     - Returns: Returns the array of random bytes.
     */
    func randomBytes(count: Int) -> [UInt8];
    
    // MARK: - Public Key
    
    func generateKeyPair(for identity: Identity, role: SecKeyType, completionHandler completion: @escaping (Error?) -> Void);
    
    func generateCertificate(for identity: Identity, role: SecKeyType, completionHandler completion: @escaping (Error?) -> Void);
    
    func loadCertificate(from data: Data) -> Certificate?;
    
    /**
     Get certificate for identity.
     
     Gets the public key certifcate for the specified identity.
     
     - Parameters:
        - identity: Identifies the principal.
     
     - Returns:
        Returns the certificate for identity, or nil if a certificate does not
        exist.
     */
    func getCertificate(for identity: Identity, role: SecKeyType) -> Certificate?;
    
    
    // MARK: - Shared Secret
    
    /**
     Intern shared secret.
     
     Interns a shared secret within the security enclave for the specified
     identity.  Any existing shared secret associated with identity will be
     lost.
     
     - Parameters:
        - secret:    The secret to be interned within the security enclave.
        - identity:  The identity to which the shared secret will be associated.
        - completion A completion handler that will be invoked will the result
                     of the operation.
     
     - Remarks:
        Password strings may be converted to a byte array by encoding the
        string as a UTF-8 byte sequence.
     */
    func internSharedKey(for identity: Identity, with secret: [UInt8], completionHandler completion: @escaping (Error?, Key?) -> Void);
    
    func loadSharedKey(for identity: Identity) -> Key?;
    
    /**
     Remove shared secret.
     
     Removes a shared secret from the security enclave that was previously
     interned for identity.
     
     - Parameters:
        - identity:  The identity to which the shared secret will be associated.
        - completion A completion handler that will be invoked will the result
                     of the operation.
     */
    func removeSharedKey(for identity: Identity, completionHandler completion: @escaping (Error?) -> Void);

    
}


// End of File
