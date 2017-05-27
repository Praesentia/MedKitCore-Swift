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
 Network backend.
 
 A device backend that has responsibility for managing a network connection.
 */
class NetBackend: Backend, ConnectionDelegate {
    
    // MARK: - Properties
    private(set) var isOpen    : Bool = false;
    var              ports     = NetPorts();
    var              reachable : Bool { return ports.reachable }
    
    // MARK: - Private
    private weak var device     : DeviceProxyNet!;
    private var      connection : ClientConnection!;
    private var      syncClose  = Wait();
    private var      syncOpen   = Wait();
    
    // MARK: - Initializers
    
    /**
     Initialize instance.
     */
    init(device: DeviceProxyNet)
    {
        self.device = device;
    }
    
    // MARK: - Connectivity
    
    /**
     Connect with completion hander.
     
     This method is used to open a connection to a device.
     
     - Parameters:
        - principal:
        - completion:
     */
    private func connect(as principal: Principal?, completionHandler completion: @escaping (Error?) -> Void)
    {
        if let port = ports.selectPort() {
            if let connection = port.instantiateConnection(as: principal) {
                connection.start() { error in
                    
                    if error == nil {
                        connection.delegate = self;
                        self.connection = connection;
                    }
                    
                    completion(error);
                }
            }
            else {
                DispatchQueue.main.async() { completion(MedKitError.Unreachable); }
            }
        }
        else {
            DispatchQueue.main.async() { completion(MedKitError.Unreachable); }
        }
    }
    
    /**
     Open connection to device.
     */
    func open(_ device: DeviceBackend, completionHandler completion: @escaping (Error?) -> Void)
    {
        syncOpen.wait(completionHandler: completion);
        
        if syncOpen.first {
            connect(as: PrincipalManager.main.primary) { error in
                if error == nil {
                    self.connection.backend.deviceOpen(device) { error in
                        self.isOpen = true;
                        self.device.connected();
                        self.syncOpen.complete(error);
                    }
                }
                else {
                    self.syncOpen.complete(error);
                }
            }
        }
    }
    
    // MARK: - ConnectionDelegate
    
    /**
     Connection did closed.
     
     - Parameters:
        - connection: The connection that was closed.
        - error: The reason why the connection closed.  A value of nil
            indicates a normal, client initiated shutdown.
     */
    func connectionDidClose(_ connection: Connection, for reason: Error?)
    {
        self.connection.backend.deviceClose(device, for: reason) { error in
            
            // TODO
            if error == nil {
                self.device.backend = self;
                self.isOpen         = false;
                self.device.disconnected(for: reason);
            }
            
            self.connection = nil;
            self.syncClose.complete(nil);
        }
    }
    
    // MARK: - DeviceBackendDelegate
    
    
    /**
     Close connection to device.
     */
    func deviceClose(_ device: DeviceBackend, for reason: Error?, completionHandler completion: @escaping (Error?) -> Void)
    {
        syncClose.wait(completionHandler: completion);
        
        if syncClose.first {
            if let connection = self.connection {
                connection.shutdown(for: reason);
            }
            else {
                syncClose.complete(nil);
            }
        }
    }
    
    /**
     Open connection to device.
     */
    func deviceOpen(_ device: DeviceBackend, completionHandler completion: @escaping (Error?) -> Void)
    {
        if connection == nil {
            open(device, completionHandler: completion);
        }
        else {
            DispatchQueue.main.async { completion(nil); }
        }
    }
    
    /**
     Update device name.
     */
    func device(_ device: DeviceBackend, updateName name: String, completionHandler completion: @escaping (Error?) -> Void)
    {
        open(device) { error in
            if error == nil {
                self.connection.backend.device(device, updateName: name, completionHandler: completion);
            }
            else {
                completion(error);
            }
        }
    }
    
    // MARK: - ServiceBackendDelegate
    
    /**
     Update service name.
     */
    func service(_ service: ServiceBackend, updateName name: String, completionHandler completion: @escaping (Error?) -> Void)
    {
        open(service.deviceBackend) { error in
            if error == nil {
                self.connection.backend.service(service, updateName: name, completionHandler: completion);
            }
            else {
                completion(error);
            }
        }
    }
    
    // MARK: - ResourceBackendDelegate
    
    /**
     Enable notification.
     */
    func resourceEnableNotification(_ resource: ResourceBackend, completionHandler completion: @escaping (ResourceCache?, Error?) -> Void)
    {
        let device = resource.serviceBackend.deviceBackend!;
        
        open(device) { error in
            if error == nil {
                self.connection.backend.resourceEnableNotification(resource, completionHandler: completion);
            }
            else {
                completion(nil, error);
            }
        }
    }
    
    /**
     Disable notification.
     */
    func resourceDisableNotification(_ resource: ResourceBackend, completionHandler completion: @escaping (Error?) -> Void)
    {
        let device = resource.serviceBackend.deviceBackend!;
        
        open(device) { error in
            if error == nil {
                self.connection.backend.resourceDisableNotification(resource, completionHandler: completion);
            }
            else {
                completion(error);
            }
        }
    }
    
    /**
     Read value.
     */
    func resourceReadValue(_ resource: ResourceBackend, completionHandler completion: @escaping (ResourceCache?, Error?) -> Void)
    {
        let device = resource.serviceBackend.deviceBackend!;
        
        open(device) { error in
            if error == nil {
                self.connection.backend.resourceReadValue(resource, completionHandler: completion);
            }
            else {
                completion(nil, error);
            }
        }
    }
    
    /**
     Write value.
     */
    func resourceWriteValue(_ resource: ResourceBackend, _ value: JSON?, completionHandler completion: @escaping (ResourceCache?, Error?) -> Void)
    {
        let device = resource.serviceBackend.deviceBackend!;
        
        open(device) { error in
            if error == nil {
                self.connection.backend.resourceWriteValue(resource, value, completionHandler: completion);
            }
            else {
                completion(nil, error);
            }
        }
    }
    
}


// End of File
