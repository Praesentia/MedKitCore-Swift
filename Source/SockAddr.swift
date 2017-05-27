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
 Socket address.
 
 The socket address incorporates the IP address, protocol and port number.
 */
public class SockAddr: Equatable {
    
    // MARK: - Properties
    public let               proto   : InetProto;
    public var               address : InetAddress      { return InetAddress(address: storage); }
    public var               port    : UInt16           { return getPort(); }
    public var               len     : socklen_t        { return getLength(); }
    public var               string  : String?          { return toString(); }
    public internal(set) var storage = sockaddr_storage();
    
    // MARK: - Equatable
    
    public static func ==(lhs: SockAddr, rhs: SockAddr) -> Bool
    {
        return lhs.proto == rhs.proto && lhs.address == rhs.address && lhs.port == rhs.port;
    }
    
    // MARK: - Initializers
    
    /**
     Instantiate instance.
     
     - Parameters:
        - stack: Inet protocol type.
     */
    public init(proto: InetProto)
    {
        self.proto        = proto;
        storage.ss_family = sa_family_t(AF_INET);
    }
    
    /**
     Instantiate instance.
     
     - Parameters:
        - stack:   Inet protocol type.
        - address: Inet address.
     */
    public init(proto: InetProto, address: sockaddr_storage)
    {
        self.proto = proto;
        storage    = address;
    }
    
    /**
     Instantiate instance.
     
     - Parameters:
        - stack:   Inet protocol type.
        - address: Inet address as data.
     */
    public init(proto: InetProto, address: Data)
    {
        self.proto = proto;
        
        withUnsafeMutablePointer(to: &storage) {
            $0.withMemoryRebound(to: UInt8.self, capacity: 1) {
                address.copyBytes(to: $0, count: address.count);
            }
        }
    }
    
    // MARK: -
    
    private func getLength() -> socklen_t
    {
        switch address.family {
        case AF_INET :
            return socklen_t(MemoryLayout<sockaddr_in>.size);
            
        case AF_INET6 :
            return socklen_t(MemoryLayout<sockaddr_in6>.size);
            
        default :
            return socklen_t(MemoryLayout<sockaddr_storage>.size);
        }
    }
    
    private func getPort() -> UInt16
    {
        switch address.family {
        case AF_INET :
            var addr4 = sockaddr_in();
            
            withUnsafePointer(to: &storage) {
                $0.withMemoryRebound(to: sockaddr_in.self, capacity: 1) {
                    addr4 = $0.pointee;
                }
            }
            
            return CFSwapInt16HostToBig(addr4.sin_port);
            
        case AF_INET6 :
            var addr6 = sockaddr_in6();
            
            withUnsafePointer(to: &storage) {
                $0.withMemoryRebound(to: sockaddr_in6.self, capacity: 1) {
                    addr6 = $0.pointee;
                }
            }
            
            return CFSwapInt16HostToBig(addr6.sin6_port);
            
        default :
            return 0;
        }
    }
    
    private func toString() -> String?
    {
        if let host = self.address.string {
            return "\(host):\(port)";
        }
        return nil;
    }
    
}


// End of File
