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
 Port tap.
 
 The PortTap component may be placed between any two members of a protocol
 stack to monitor the data flow between them.
 */
public class PortTap: Port, PortDelegate {
    
    // MARK: - Properties
    public weak var dataTap  : DataTap?;
    public weak var delegate : PortDelegate?;
    
    // MARK: - Private Properties
    private let port           : Port;
    private let decoderFactory : DecoderFactory;
    
    // MARK: - Initializers
    
    /**
     Initialize instance.
     
     - Parameters:
        - port:
        - decoderFactory:
     */
    public init(_ port: Port, decoderFactory: DecoderFactory)
    {
        self.port           = port;
        self.decoderFactory = decoderFactory;
        
        port.delegate = self;
    }
    
    // MARK: - Lifecycle
    
    public func shutdown(for reason: Error?)
    {
        port.shutdown(for: reason);
    }
    
    public func start()
    {
        port.start();
    }
    
    // MARK: - Output
    
    public func send(_ data: Data)
    {
        dataTap?.dataTap(self, willSend: data, decoderFactory: decoderFactory);
        port.send(data);
    }
    
    // MARK: - PortDelegate
    
    public func portDidClose(_ port: Port, for reason: Error?)
    {
        delegate?.portDidClose(self, for: reason);
    }
    
    public func portDidInitialize(_ port: Port, with error: Error?)
    {
        delegate?.portDidInitialize(self, with: error);
    }
    
    public func port(_ port: Port, didReceive data: Data)
    {
        dataTap?.dataTap(self, didReceive: data, decoderFactory: decoderFactory);
        delegate?.port(self, didReceive: data);
    }
    
}


// End of File
