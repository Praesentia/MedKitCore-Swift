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
 Connection
 
 Connection is a base class used to manage a single communication session,
 as a container for the associated protocol stack.
 */
open class Connection: ProtocolStackDelegate {
    
    // public
    open var dataSink : DataSink? {
        get        { return nil; }
        set(value) { }
    }
    
    public weak var delegate : ConnectionDelegate?;
    public let      port     : Port;                //: The base port, at the bottom of the protocol stack.
    
    // MARK: - Private
    private var completion: ((Error?) -> Void)?;    //: Completion handler for the start() method.
    
    /**
     Initialize instance.
     
     - Parameters:
        - port: The base port, to be installed at the bottom of the protocol
                stack.
     */
    public init(port: Port)
    {
        self.port = port;
    }
    
    /**
     Complete startup.
     
     Completes the startup sequence by invoking the completion handler
     originally passed to the start(_:completionHandler:) method.
     
     - Parameters:
        - error: Forwarded to the completion handler.
     */
    open func complete(_ error: Error?)
    {
        if let completion = self.completion {
            completion(error);
            self.completion = nil;
        }
    }
    
    /**
     Start protocol stack.
     
     Initiates the startup of the protocol stack.
     
     - Parameters:
        - completion: The completion handler.
     */
    open func start(completionHandler completion: @escaping (Error?)->Void)
    {
        self.completion = completion;
        port.start();
    }
    
    /**
     Shutdown connection.
     
     - Parameters:
        - reason: Nil indicates a normal shutdown.  Otherwise, an error
                  indicating the reason that led to the connection being closed.
     */
    open func shutdown(reason: Error?)
    {
        port.shutdown(reason: reason);
    }
    
    // MARK: - ProtocolStackDelegate
    
    open func protocolStackDidInitialize(_ stack: ProtocolStack, with error: Error?)
    {
        complete(error);
    }
    
    open func protocolStackDidClose(_ stack: ProtocolStack, reason: Error?)
    {
        complete(MedKitError.Unreachable);
        delegate?.connectionDidClose(self, reason: reason);
    }
    
}


// End of File
