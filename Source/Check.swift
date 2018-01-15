/*
 -----------------------------------------------------------------------------
 This source file is part of MedKitCore.
 
 Copyright 2016-2018 Jon Griffeth
 
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
 Simple boolean results acculumator.
 */
public func +=(check: Check, value: Bool)
{
    check.update(value)
}

/**
 Simple results acculumator.
 */
public class Check {
    
    // MARK: - Properties
    public private(set) var value: Bool = true
    
    // MARK: - Initializers
    
    public init()
    {
    }
    
    // MARK: - Update
    
    public func update(_ value: Bool)
    {
        if !value {
            self.value = false
        }
    }

}


// End of File
