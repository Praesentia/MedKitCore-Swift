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
 Communications endpoint.
 
 A base class for communication endpoints.
 */
class Endpoint {
    
    // MARK: - Class Properties
    static let closed     : Int =  0
    static let failed     : Int = -1
    static let wouldBlock : Int = -2
    
    // MARK: - Properties
    weak var delegate : EndpointDelegate? //: Delegate
    
    /**
     Resume input.
     */
    func resumeIn()
    {
    }
    
    /**
     Resume output.
     */
    func resumeOut()
    {
    }
    
    /**
     */
    func shutdown()
    {
    }
    
}


// End of File
