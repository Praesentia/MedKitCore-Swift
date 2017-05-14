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
 Credentials factory.
 */
public class CredentialsFactoryDB {
    
    // MARK: - Class Properties
    public static let main = CredentialsFactoryDB();
    
    // MARK: - Private
    private var factories = [ CredentialsType : CredentialsFactory ]();
    
    // MARK: - Initializers
    
    /**
     Initialize instance.
     */
    private init()
    {
        factories[.SharedSecret] = SharedSecret.factory;
        factories[.PublicKey]    = PublicKeyCredentials.factory;
    }
    
    // MARK: - Instantiation
    
    /**
     Create credentials from profile, for identity.
     */
    public func instantiate(from profile: JSON, for identity: Identity) -> Credentials
    {
        if let string = profile[KeyType].string, let type = CredentialsType(string: string) {
            if let factory = factories[type] {
                return factory.instantiate(from: profile, for: identity);
            }
        }
        
        return NullCredentials.shared;
    }
    
}


// End of File
