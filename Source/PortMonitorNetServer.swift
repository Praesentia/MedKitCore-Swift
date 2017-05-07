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
 Network server port monitor.
 */
public class PortMonitorNetServer: PortMonitorNetListener {
    
    private let connectionFactory : ServerConnectionFactory;
    private let device            : DeviceFrontend;
    private let myself            : Principal;
    
    /**
     Initialize instance.
     */
    public init(address: SockAddr, connectionFactory: ServerConnectionFactory, device: DeviceFrontend, as myself: Principal)
    {
        self.connectionFactory = connectionFactory;
        self.device            = device;
        self.myself            = myself;
        
        super.init(address: address);
    }
    
    /**
     Create connection for endpoint.
     
     - Parameters:
        - address:
     */
    override func instantiateConnection(to endpoint: EndpointNet) -> Connection?
    {
        let port       = PortNetTCP(endpoint: endpoint);
        let connection = connectionFactory.instantiate(from: port, to: device, as: myself);
        
        connection.start() { error in
            if error == nil {
            }
        }
        
        return connection;
    }
    
    /**
     Publish service.
     
     - Parameters:
        - address:
     */
    override func publishService(using address: SockAddr) -> ServiceResponder?
    {
        var serviceResponder : ServiceResponder;

        serviceResponder = ServiceResponder(device: device, protocolType: connectionFactory.protocolType, port: address.port);
        serviceResponder.publish();
        
        return serviceResponder;
    }
    
}


// End of File
