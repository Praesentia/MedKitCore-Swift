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
 
 A device backend that has responsibility for managing network connections.
 */
class NetBackend: Backend, ConnectionDelegate {
    
    // public
    var ports     = NetPorts();
    var reachable : Bool { return ports.reachable; }
   
    //private
    private weak var device     : DeviceProxyBase!;
    private var      connection : ClientConnection!;
    private var      sync       = Wait();
    
    /**
     Initialize instance.
     */
    init(device: DeviceProxyBase)
    {
        self.device = device;
    }
    
    /**
     Connect with completion hander.
     
     This method is used to open a connection to the device.  If successful,
     the completion handler will be called with a new Backend instance.
     
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
        sync.wait(completionHandler: completion);
        
        if sync.first {
            connect(as: PrincipalManager.main.primary) { error in
                if error == nil {
                    self.connection.backend.deviceOpen(device) { error in
                        self.sync.complete(error);
                    }
                }
                else {
                    self.sync.complete(error);
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
    func connectionDidClose(_ connection: Connection, reason: Error?)
    {
        self.connection.backend.deviceClose(device, reason: reason) { error in
            
            // TODO
            if error == nil {
                self.device.backend = self;
                self.device.observers.withEach { $0.deviceDidClose(self.device, reason: reason); }
            }
            
            self.connection = nil;
        }
    }
    
    // MARK: - DeviceObserver
    
    
    /**
     Close connection.
     */
    func deviceClose(_ device: DeviceBackend, reason: Error?, completionHandler completion: @escaping (Error?) -> Void)
    {
        connection?.shutdown(reason: reason);
        completion(nil);
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
    
    // MARK: - ServiceObserver
    
    func service(_ service: ServiceBackend, updateName name: String, completionHandler completion: @escaping (Error?) -> Void)
    {
        open(service.deviceBackend!) { error in
            if error == nil {
                self.connection.backend.service(service, updateName: name, completionHandler: completion);
            }
            else {
                completion(error);
            }
        }
    }
    
    // MARK: - ResourceObserver
    
    func resourceEnableNotification(_ resource: ResourceBackend, completionHandler completion: @escaping (ResourceCache?, Error?) -> Void)
    {
        let device = resource.serviceBackend!.deviceBackend!;
        
        open(device) { error in
            if error == nil {
                self.connection.backend.resourceEnableNotification(resource, completionHandler: completion);
            }
            else {
                completion(nil, error);
            }
        }
    }
    
    func resourceDisableNotification(_ resource: ResourceBackend, completionHandler completion: @escaping (Error?) -> Void)
    {
        let device = resource.serviceBackend!.deviceBackend!;
        
        open(device) { error in
            if error == nil {
                self.connection.backend.resourceDisableNotification(resource, completionHandler: completion);
            }
            else {
                completion(error);
            }
        }
    }
    
    func resourceReadValue(_ resource: ResourceBackend, completionHandler completion: @escaping (ResourceCache?, Error?) -> Void)
    {
        let device = resource.serviceBackend!.deviceBackend!;
        
        open(device) { error in
            if error == nil {
                self.connection.backend.resourceReadValue(resource, completionHandler: completion);
            }
            else {
                completion(nil, error);
            }
        }
    }
    
    func resourceWriteValue(_ resource: ResourceBackend, _ value: JSON?, completionHandler completion: @escaping (ResourceCache?, Error?) -> Void)
    {
        let device = resource.serviceBackend!.deviceBackend!;
        
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
