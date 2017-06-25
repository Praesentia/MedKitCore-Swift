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
 MIST V1 Schema
 */
class MISTV1Schema: ServiceTypeSchema {
    
    // MARK: - Private
    private let RequiredTXT   = [ "dn", "dt", "md", "mf", "pr", "sn", "vn" ]
    private let VersionString = "1"
    
    /**
     Verify TXT fields.
     
     - Parameters:
        - txt: Dictionary of key/value pairs derived from an associated TXT
               record.
     */
    func verifyTXT(_ txt: [String : String]) -> Bool
    {
        if let version = txt["vn"] {
            switch version {
            case VersionString :
                for key in RequiredTXT {
                    if txt[key] == nil {
                        return false
                    }
                }
                return true
                
            default :
                return false
            }
        }
        
        return false
    }
    
}


// End of File
