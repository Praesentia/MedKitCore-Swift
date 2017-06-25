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


import Foundation


/**
 Identity
 
 - Remarks:
    Identity instances are immutable to prevent unintended side-effects.
    Changes to an identity requires the creation of a new instance.
 */
public class Identity: Equatable {
    
    /**
     Identity type.
     
     Different types of identities may use different naming conventions.  The
     identity type separates namespaces to prevent conflicts.
     */
    public enum IdentityType {
        case device       //: Devices.
        case organization //: An organization, such as a certificate authority.
        case other
        case user         //: An actual person.
    }
    
    // MARK: - Properties
    public var  profile : JSON         { return getProfile() }
    public let  name    : String
    public let  type    : IdentityType
    public var  string  : String       { return "\(type.prefix)\(name)" }
    
    // MARK: - Initializers
    
    /**
     Initialize instance.
     */
    public init(named name: String, type: IdentityType)
    {
        self.name = name
        self.type = type
    }
    
    /**
     Initialize instance from profile.
     */
    public init(from profile: JSON)
    {
        self.name = profile[KeyName].string!
        self.type = IdentityType(string: profile[KeyType].string!)!
    } 
    
    /**
     Initialize instance from string.
     */
    public convenience init?(from string: String) // TODO
    {
        var t: IdentityType?
        var n: String?
        
        if string.hasPrefix(Identity.IdentityType.PrefixDevice) {
            n = String(string.characters.suffix(string.characters.count - 18))
            t = .device
        }
    
        if string.hasPrefix(Identity.IdentityType.PrefixUser) {
            n = String(string.characters.suffix(string.characters.count - 16))
            t = .user
        }
    
        if string.hasPrefix(Identity.IdentityType.PrefixOrganization) {
            n = String(string.characters.suffix(string.characters.count - 24))
            t = .organization
        }
        
        if t != nil {
            self.init(named: n!, type: t!)
        }
        else {
            self.init(named: string, type: .other)
        }
    }
    
    // MARK: - Profile Management
    
    private func getProfile() -> JSON
    {
        let profile = JSON()
        
        profile[KeyName] = name
        profile[KeyType] = type.string
        
        return profile
    }
    
}

// MARK: - Equatable

/**
 Identity equatable operator.
 */
public func ==(lhs: Identity, rhs: Identity) -> Bool
{
    return lhs.name == rhs.name && lhs.type == rhs.type
}

// MARK: - Extensions

public extension Identity.IdentityType {
    
    static let PrefixDevice       = "org.medkit.device."
    static let PrefixOrganization = "org.medkit.organization."
    static let PrefixOther        = ""
    static let PrefixUser         = "org.medkit.user."
    
    public init?(string: String)
    {
        switch string {
        case "Device" :
            self = .device
            
        case "Organization" :
            self = .organization
            
        case "Other" :
            self = .other
            
        case "User" :
            self = .user

        default :
            return nil
        }
    }
    
    public var prefix: String {
        switch self {
        case .device :
            return Identity.IdentityType.PrefixDevice
            
        case .organization :
            return Identity.IdentityType.PrefixOrganization
            
        case .other :
            return Identity.IdentityType.PrefixOther
            
        case .user :
            return Identity.IdentityType.PrefixUser
        }
    }
    
    public var string: String {
        switch self {
        case .device :
            return "Device"
        
        case .organization :
            return "Organization"
            
        case .other :
            return "Other"
        
        case .user :
            return "User"
        }
    }
    
}


// End of File
