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
 Security manager protocol.
 
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
    
    /**
     Get credentials for identity.
     
     - Parameters:
        - identity: Identifies the principal.
     
     - Returns:
        Returns the credentials for identity, or nil if the credentials do not
        exist.
     */
    func getCredentials(for identity: Identity, using type: CredentialsType) -> Credentials?;
    
    // MARK: - Digest
    
    func digest(using: DigestType) -> Digest;
    
    // MARK: - Random
    
    /**
     Generate random bytes.
     
     Generates an array of random bytes.
     
     - Parameters:
        - count: Size of the returned array.
     
     - Returns: Returns the array of random bytes.
     */
    func randomBytes(count: Int) -> [UInt8];
    
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
    func internSecret(_ secret: [UInt8], for identity: Identity, completionHandler completion: @escaping (Error?) -> Void);
    
    /**
     Remove shared secret.
     
     Removes a shared secret from the security enclave that was previously
     interned for identity.
     
     - Parameters:
        - identity:  The identity to which the shared secret will be associated.
        - completion A completion handler that will be invoked will the result
                     of the operation.
     */
    func removeSecret(for identity: Identity, completionHandler completion: @escaping (Error?) -> Void);
    
    // MARK: - Public Key
    
    func generateKeyPair(for identity: Identity, completionHandler completion: @escaping (Error?) -> Void);
    
    /**
     Get certificate for identity.
     
     Gets the public key certifcate for the specified identity.
     
     - Parameters:
        - identity: Identifies the principal.
     
     - Returns:
        Returns the certificate for identity, or nil if a certificate does not
        exist.
     */
    func getCertificate(for identity: Identity) -> Certificate?;
    
    /**
     Placeholder.
     */
    func verify(certificate: Certificate, for identity: Identity) -> Bool;
    
    /**
     Placeholder.
     */
    func verifySignature(_ signature: [UInt8], for certificate: Certificate, bytes: [UInt8]) -> Bool;
    
    // MARK: - Signing and Verification
    
    /**
     Sign bytes for identity.
     
     Generate a signature for the specified bytes using the private credentials
     associated with identity.
     
     - Parameters:
        - bytes:    The byte sequence to be signed.
        - identity: Identifies the principal.
     
     - Returns:
        Returns the signature as a sequence a bytes, or nil if the required
        credentials for identity do not exist.
     
     - Remarks:
        The bytes to be signed are often a hash
     */
    func signBytes(_ bytes: [UInt8], for identity: Identity, using type: CredentialsType) -> [UInt8]?;
    
    /**
     Verify signature for identity.
     
     - Parameters:
        - signature: The signature to be verified.
        - identity:  Identifies the principal.
        - bytes:     The byte sequence to be verified.
     */
    func verifySignature(_ signature: [UInt8], for identity: Identity, bytes: [UInt8], using type: CredentialsType) -> Bool;
    
}


// End of File
