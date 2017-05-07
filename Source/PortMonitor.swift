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


public protocol PortMonitorDelegate: class {
    
    func portMonitorDidClose(_ portMonitor: PortMonitor, reason: Error?);
    func portMonitor(_ portMonitor: PortMonitor, didAdd connection: Connection);
    func portMonitor(_ portMonitor: PortMonitor, didRemove connection: Connection);
    func portMonitor(_ portMonitor: PortMonitor, shouldAccept address: SockAddr) -> Bool;
    
}

public extension PortMonitorDelegate {
    
    func portMonitorDidClose(_ portMonitor: PortMonitor, reason: Error?)
    {
    }
    
    func portMonitor(_ portMonitor: PortMonitor, didAdd connection: Connection)
    {
    }
    
    func portMonitor(_ portMonitor: PortMonitor, didRemove connection: Connection)
    {
    }
    
    func portMonitor(_ portMonitor: PortMonitor, shouldAccept address: SockAddr) -> Bool
    {
        return true;
    }
    
}


/**
 Port Monitor
 */
public class PortMonitor {
    
    public enum State {
        case Closed;
        case Open;
        case Shutdown;
    }
    
    public var      count   : Int { return 0; }
    public weak var delegate: PortMonitorDelegate?;
    public var      state   : State { return _state; }
    public var      enabled : Bool  { return _state == .Open; }

    var _state: State = .Closed;
    
    public init()
    {
    }
    
    /**
     Start monitor.
     */
    public func start()
    {
    }
    
    /**
     Shutdown monitor.
     */
    public func shutdown(reason: Error?)
    {
        DispatchQueue.main.async() { self.delegate?.portMonitorDidClose(self, reason: reason); }
    }
    
}


// End of File
