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
 Network port collection.
 */
class NetPorts {
    
    // MARK: - Properties
    private(set) var ports     = [NetPortFactory]()
    var              reachable : Bool { return reachablePorts() }
    
    // MARK: - Initializers
    
    /**
     Initialize instance.
     */
    init()
    {
    }
    
    // MARK: - Port Management
    
    /**
     Add port factory.
     */
    func addPort(_ port: NetPortFactory)
    {
        ports.append(port)
    }
    
    /**
     Remove port factory.
     */
    func removePort(_ port: PortFactory)
    {
        if let index = (ports.index { $0 === port }) {
            ports.remove(at: index)
        }
    }
    
    /**
     Remove all port factories.
     */
    func removeAllPorts()
    {
        ports.removeAll()
    }
    
    // MARK: - Port Selection
    
    /**
     Are there any reachable ports?
     */
    private func reachablePorts() -> Bool
    {
        for port in ports {
            if port.reachable {
                return true
            }
        }
        
        return false
    }
    
    /**
     Select port.
     */
    func selectPort() -> NetPortFactory?
    {
        var selection: NetPortFactory?
        
        for port in ports {
            if port.reachable {
                if selection == nil || port.priority < selection!.priority {
                    selection = port
                }
            }
        }
        
        return selection
    }
    
}


// End of File
