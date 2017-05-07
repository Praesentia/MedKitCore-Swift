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
 Port logger.
 */
public class PortLogger: Port, PortDelegate {
    
    weak public var delegate : PortDelegate?; //: Delegate
    
    public weak var dataSink       : DataSink?;
    public let      port           : Port;
    public let      decoderFactory : DecoderFactory;
    
    public init(_ port: Port, decoderFactory: DecoderFactory)
    {
        self.port           = port;
        self.decoderFactory = decoderFactory;
        
        port.delegate = self;
    }
    
    public func send(_ data: Data)
    {
        dataSink?.dataSink(self, willSend: data, decoderFactory: decoderFactory);
        port.send(data);
    }
    
    public func shutdown(reason: Error?)
    {
        port.shutdown(reason: reason);
    }
    
    public func start()
    {
        port.start();
    }
    
    // MARK: - PortDelegate
    
    public func portDidInitialize(_ port: Port, with error: Error?)
    {
        delegate?.portDidInitialize(self, with: error);
    }
    
    public func portDidClose(_ port: Port, reason: Error?)
    {
        delegate?.portDidClose(self, reason: reason);
    }
    
    public func port(_ port: Port, didReceive data: Data)
    {
        dataSink?.dataSink(self, didReceive: data, decoderFactory: decoderFactory);
        delegate?.port(self, didReceive: data);
    }
    
}


// End of File
