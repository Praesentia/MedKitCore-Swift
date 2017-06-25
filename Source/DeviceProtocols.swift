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


public class DeviceProtocols {
    
    // MARK: - Class Properties
    public static let main = DeviceProtocols()
    
    // MARK: - Properties
    public var protocols : [DeviceProtocol] { return deviceProtocols.map { $0.1 } }

    // MARK: - Private Properties
    private var deviceProtocols = [String : DeviceProtocol]()
    
    // MARK: - Initializers
    
    private init()
    {
    }
    
    // MARK: - Protocol Management
    
    public func findProtocol(named name: String) -> DeviceProtocol?
    {
        return deviceProtocols[name]
    }
    
    public func registerProtocol(_ deviceProtocol: DeviceProtocol)
    {
        deviceProtocols[deviceProtocol.identifier] = deviceProtocol
    }
    
}


// End of File
