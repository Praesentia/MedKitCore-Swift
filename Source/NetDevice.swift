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
 Network device.
 */
class NetDevice {

    // public
    let      info      : DeviceInfo;
    weak var observer  : NetDeviceObserver?; //: Only one observer supported.
    var      ports     : [NetPortFactory] { return _ports; }
    
    // MARK: - Shadowed
    var _ports     = [NetPortFactory]();
    var _suspended = false;
    
    /**
     Initialize instance from device metadata.
     */
    init(from info: DeviceInfo)
    {
        self.info = info;
    }
    
    /**
     Add port.
     */
    func addPort(_ port: NetPortFactory)
    {
        _ports.append(port);
        observer?.netDevice(self, didAdd: port);
    }
    
    /**
     Remove port.
     */
    func removePort(_ port: NetPortFactory)
    {
        if let index = (ports.index() { $0 === port }) {
            _ports.remove(at: index);
            observer?.netDevice(self, didRemove: port);
        }
    }
    
}


// End of File
