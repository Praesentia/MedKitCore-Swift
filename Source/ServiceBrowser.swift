/*
 -----------------------------------------------------------------------------
 This source file is part of MedKitCore.
 
 Copyright 2016-2018 Jon Griffeth
 
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
 Service browser.
 
 The ServiceBrowser is used to discover DNS-SD services.
 */
class ServiceBrowser: NSObject, NetServiceBrowserDelegate, NetServiceDelegate {

    // MARK: - Properties
    weak var         delegate : ServiceBrowserDelegate?
    private(set) var devices  = [NetDevice]()
    var              domains  : [String] { return browsers.map { $0.0 } }
    
    // MARK: - Private
    private let ServiceType = "_mist._tcp"
    private var browsers    = [String : NetServiceBrowser]()
    private var services    = [NetService : NetServiceExt]()
    private let schema      = MISTV1Schema()
 
    /**
     Initialize instance.
     */
    override init()
    {
        super.init()
    }
    
    /**
     Resume browsing.
     */
    func resume()
    {
        for (domain, browser) in browsers {
            browser.searchForServices(ofType: ServiceType, inDomain: domain)
        }
    }
    
    /**
     Suspend browsing.
     */
    func suspend()
    {
        for (_, browser) in browsers {
            browser.stop()
        }
        
        while !devices.isEmpty {
            let device = devices.removeFirst()
            delegate?.serviceBrowser(self, didRemove: device)
        }

        services.removeAll()
    }
    
    /**
     Start browsing for services in domain.
     */
    func startBrowsing(domain: String)
    {
        if browsers[domain] == nil {
            let browser = NetServiceBrowser()
        
            browsers[domain] = browser
        
            browser.delegate = self
            browser.searchForServices(ofType: ServiceType, inDomain: domain)
        }
    }
    
    /**
     Stop browsing.
     */
    func stopBrowsing()
    {
        for (_, browser) in browsers {
            browser.stop()
        }
        
        while !devices.isEmpty {
            let device = devices.removeFirst()
            delegate?.serviceBrowser(self, didRemove: device)
        }
        
        browsers.removeAll()
        services.removeAll()
    }
    
    /**
     Stop browsing for services in domain.
     
     - Parameters:
        - domain:
     */
    func stopBrowsing(domain: String)
    {
        if let browser = browsers[domain] {
            browsers[domain] = nil
            browser.stop()
            
            for (netService, service) in services {
                if service.browser == browser {
                    services[netService] = nil
                    
                    if let device = service.device {
                        for port in service.ports {
                            device.removePort(port)
                        }
                        pruneDevice(device)
                    }
                }
            }
        }
    }
    
    /**
     Intern device.
     */
    private func internDevice(fromTXT txt: [String : String]) -> NetDevice
    {
        let info   = DeviceInfo(fromTXT: txt, version: .v1)
        var device : NetDevice! = devices.find(where: { $0.info.identifier == info.identifier })

        if device == nil {
            device = NetDevice(from: info)
            
            devices.append(device)
            delegate?.serviceBrowser(self, didAdd: device)
        }
        
        return device
    }
    
    /**
     Prune device.
     */
    private func pruneDevice(_ device: NetDevice)
    {
        if device.ports.isEmpty {
            if let index = (devices.index { $0 === device }) {
                devices.remove(at: index)
                delegate?.serviceBrowser(self, didRemove: device)
            }
        }
    }
    
    /**
     Parse TXT fields from TXT record.
     */
    private func parseTXT(fromTXTRecord record: Data) -> [String : String]?
    {
        let pairs = NetService.dictionary(fromTXTRecord: record)
        var txt   = [String : String]()
        
        for (key, data) in pairs {
            if let value = String(data: data, encoding: .utf8) {
                txt[key] = value
            }
        }
        
        return schema.verifyTXT(txt) ? txt : nil
    }
    
    // MARK: - NetServiceBrowserDelegate
    
    /**
     Browser did find service.
     */
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool)
    {
        services[service] = NetServiceExt(browser, service)
        
        service.delegate = self
        service.startMonitoring()
        service.resolve(withTimeout: 0)
    }
    
    /**
     Browser did remove service.
     */
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove netService: NetService, moreComing: Bool)
    {
        if let service = services[netService] {
            services[netService] = nil
            
            if let device = service.device {
                
                for port in service.ports {
                    device.removePort(port)
                }
            
                if device.ports.isEmpty {
                    if let index = (devices.index { $0 === device }) {
                        devices.remove(at: index)
                        delegate?.serviceBrowser(self, didRemove: device)
                    }
                }
            }
        }
    }
    
    // MARK: - NetServiceDelegate
    
    func netService(_ netService: NetService, didUpdateTXTRecord record: Data)
    {
        if let service = services[netService] {
            if let txt = parseTXT(fromTXTRecord: record) {
                let device = internDevice(fromTXT: txt)
                
                service.updateNetDevice(device, type: ProtocolType(fromText: txt["pr"]))
            }
        }
    }
    
    func netServiceDidResolveAddress(_ netService: NetService)
    {
        if let service = services[netService] {
            let addresses = netService.addresses ?? []
            
            service.updateAddresses(addresses.map() { SockAddr(proto: InetProto(inet: service.proto)!, address: $0) }, from: netService.domain)
        }
    }
    
}


// End of File
