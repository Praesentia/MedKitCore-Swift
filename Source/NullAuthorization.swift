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


import Foundation


/**
 Null authorization.
 */
public class NullAuthorization: Authorization {
    
    public static let shared = NullAuthorization()
    
    public var expires : TimeInterval?     { return nil }
    public var profile : JSON              { return getProfile() }
    public var string  : String            { return "null" }
    public var type    : AuthorizationType { return .null }
    
    /**
     Initialize instance.
     */
    private init()
    {
    }
    
    /**
     Is operation authorized.
     
     Always fails.
     */
    public func authorized(operation: UUID) -> Bool
    {
        return false
    }
    
    private func getProfile() -> JSON
    {
        let profile = JSON()
        
        profile[KeyType] = type.string
        
        return profile
    }
    
}


// End of File
