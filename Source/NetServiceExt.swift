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


class NetServiceExt {
    
    // public
    weak var browser : NetServiceBrowser!;
    var      service : NetService!;
    var      device  : NetDevice?;
    var      proto   : Int32 = SOCK_STREAM;
    var      ports   = [NetPortFactory]();
    var      type    : DeviceProtocol?;
    
    /**
     Initialize instance.
     */
    init(_ browser: NetServiceBrowser, _ service: NetService)
    {
        self.browser = browser;
        self.service = service;
    }
    
    /**
     Update network device.
     */
    func updateNetDevice(_ device: NetDevice, type: String?)
    {
        self.device = device;
        
        if let type = type {
            self.type = DeviceProtocols.main.findProtocol(named: type);
        }
        else {
            self.type = nil;
        }
        
        for port in ports {
            device.addPort(port);
        }
    }
    
    func updateAddresses(_ addresses: [SockAddr], from domain: String)
    {
        pruneAddresses(addresses);
        addAddresses(addresses, from: domain);
    }
    
    /**
     Add port to ports list.
     
     - Parameters:
        - port: Port to be added to the list.
     */
    private func addPort(_ port: NetPortFactory)
    {
        ports.append(port);
        device?.addPort(port);
    }
    
    /**
     Remove port from ports list.
     
     - Parameters:
        - port: Port to be removed from the list.
     */
    private func removePort(_ port: NetPortFactory)
    {
        if let index = (ports.index { $0 === port; }) {
            ports.remove(at: index);
            device?.removePort(port);
        }
    }
    
    private func containsPort(with address: SockAddr) -> Bool
    {
        return (ports.index() { port in port.address == address; }) != nil;
    }
    
    /**
     Add missing addresses to port list.
     
     - Parameters:
        - addresses: List of addresses to be obtained.
     */
    private func addAddresses(_ addresses: [SockAddr], from domain: String)
    {
        for address in addresses {
            if !containsPort(with: address) {
                if let type = self.type {
                    let port = NetPortFactory(domain: domain, type: type, address: address);
                    addPort(port);
                }
            }
        }
    }
    
    /**
     Prune missing addresses from port list.
     
     - Parameters:
        - addresses: List of addresses to be retained.
     */
    private func pruneAddresses(_ addresses: [SockAddr])
    {
        for port in ports {
            if !addresses.contains(port.address) {
                removePort(port);
            }
        }
    }
    
}


// End of File
