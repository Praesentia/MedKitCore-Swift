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


import Foundation;


/**
 Principal
 
 Represents a user account, device etc., consisting of an identity, credentials,
 and authorization.
 
 - Remarks:
    Principal instances are immutable to prevent unintended side-effects.
    Changes to a principal requires the creation of a new instance.
 */
public class Principal {
    
    // MARK: - Properties
    public let authorization: Authorization;
    public let credentials  : Credentials;
    public let identity     : Identity;
    public var profile      : JSON { return getProfile(); }
    
    // MARK: - Initializers
    
    /**
     Initialize instance.
     */
    public init(identity: Identity, credentials: Credentials, authorization: Authorization)
    {
        self.identity      = identity;
        self.credentials   = credentials;
        self.authorization = authorization;
    }
    
    /**
     Initialize instance from profile.
     */
    public init(from profile: JSON)
    {
        identity      = Identity(from: profile[KeyIdentity]);
        credentials   = CredentialsFactoryDB.main.instantiate(from: profile[KeyCredentials], for: identity);
        authorization = AuthorizationFactoryDB.main.instantiate(from: profile[KeyAuthorization]);
    }
    
    public func isaSubject(_ identity: UUID) -> Bool
    {
        return true; // TODO
    }
    
    /**
     Get profile.
     */
    private func getProfile() -> JSON
    {
        let profile = JSON();
        
        profile[KeyIdentity]      = identity.profile;
        profile[KeyCredentials]   = credentials.profilePublic;
        profile[KeyAuthorization] = authorization.profile;
        
        return profile;
    }
    
}


// End of File
