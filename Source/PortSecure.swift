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
 Secure streaming port.
 
 Placeholder.
 */
public class PortSecure: Port, PortDelegate {
    
    // MARK: - Properties
    public weak var delegate: PortDelegate?
    public weak var policy  : PortSecurePolicy?
    
    // MARK: - Private Properties
    private let port: Port
    
    // MARK: - Initializers
    
    /**
     Initialize instance.
     
     - Parameters:
        - port:
     */
    public init(_ port: Port)
    {
        self.port = port
        port.delegate = self
    }
    
    // MARK: - Lifecycle
    
    public func shutdown(for reason: Error?)
    {
        port.shutdown(for: reason)
    }
    
    public func start()
    {
        port.start()
    }
    
    // MARK: - Output
    
    public func send(_ data: Data)
    {
        port.send(data)
    }
    
    // MARK: - PortDelegate
    
    public func portDidClose(_ port: Port, for reason: Error?)
    {
        delegate?.portDidClose(self, for: reason)
    }
    
    public func portDidInitialize(_ port: Port, with error: Error?)
    {
        delegate?.portDidInitialize(self, with: error)
    }
    
    public func port(_ port: Port, didReceive data: Data)
    {
        delegate?.port(self, didReceive: data)
    }
    
}


// End of File
