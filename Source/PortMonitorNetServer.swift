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
import SecurityKit


/**
 Network server port monitor.
 */
public class PortMonitorNetServer: PortMonitorNetListener, DeviceObserver {
    
    // MARK: - Private Properties
    private let connectionFactory : ServerConnectionFactory
    private let device            : DeviceFrontend
    private let principalManager  : PrincipalManager
    
    // MARK: - Initializers
    
    /**
     Initialize instance.
     */
    public init(address: SockAddr, connectionFactory: ServerConnectionFactory, device: DeviceFrontend, using principalManager: PrincipalManager)
    {
        self.connectionFactory = connectionFactory
        self.device            = device
        self.principalManager  = principalManager
        
        super.init(address: address)
    }
    
    // MARK: - Lifecycle
    
    /**
     Publish service.
     
     - Parameters:
        - address:
     */
    override func publishService(using address: SockAddr) -> ServiceResponder?
    {
        var serviceResponder: ServiceResponder
        
        serviceResponder = ServiceResponder(device: device, protocolType: connectionFactory.protocolType, port: address.port)
        serviceResponder.publish()

        device.addObserver(self)
        
        return serviceResponder
    }

    public override func shutdown(for reason: Error?)
    {
        guard(state == .open) else { return }

        device.removeObserver(self)
        super.shutdown(for: reason)
    }
    
    // MARK: - Connection Management
    
    /**
     Create connection for endpoint.
     
     - Parameters:
        - endpoint:
     */
    override func instantiateConnection(from endpoint: EndpointNet) -> Connection?
    {
        var connection: Connection!;
        let port      = PortNetStream(endpoint: endpoint)
        
        connection = connectionFactory.instantiate(from: port, to: device, using: principalManager)
        connection.start() { error in
            if error == nil {
                // TODO
            }
        }
        
        return connection
    }

    // MARK: - DeviceObserver

    public func deviceDidUpdateName(_ device: Device)
    {
        if let serviceResponder = self.serviceResponder {
            serviceResponder.update(deviceInfo: DeviceInfo(from: device), protocolType: connectionFactory.protocolType)
        }
    }
    
}


// End of File
