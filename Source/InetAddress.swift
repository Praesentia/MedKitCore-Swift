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


import Foundation


/**
 Inet address.
 */
public class InetAddress: Equatable {
    
    // MARK: - Properties
    public var family  : Int32            { return Int32(storage.ss_family) }
    public var string  : String?          { return getHost() }
    public let storage : sockaddr_storage
    
    // MARK: - Equatable
    
    public static func ==(lhs: InetAddress, rhs: InetAddress) -> Bool
    {
        return equal(lhs.storage, rhs.storage)
    }
    
    /**
     Instantiate instance.
     
     - Parameters:
        - address: Inet address.
     */
    public init(address: sockaddr_storage)
    {
        storage = address
    }
    
    /**
     Instantiate instance.
     
     - Parameters:
        - address: sockaddr_storage data.
     */
    public init(address: Data)
    {
        var storage = sockaddr_storage()
        
        withUnsafeMutablePointer(to: &storage) {
            $0.withMemoryRebound(to: UInt8.self, capacity: 1) {
                address.copyBytes(to: $0, count: address.count)
            }
        }
        
        self.storage = storage
    }
    
    // MARK: -
    
    private func getHost() -> String?
    {
        switch family {
        case AF_INET :
            var addr4           = sockaddr_in()
            var ipAddressString = [CChar](repeating: 0, count: Int(INET_ADDRSTRLEN))
            var storage         = self.storage
            
            withUnsafePointer(to: &storage) {
                $0.withMemoryRebound(to: sockaddr_in.self, capacity: 1) {
                    addr4 = $0.pointee
                }
            }
            
            inet_ntop(AF_INET, &addr4.sin_addr, &ipAddressString, socklen_t(INET_ADDRSTRLEN))
            return String(validatingUTF8: ipAddressString)
            
        case AF_INET6 :
            var addr6           = sockaddr_in6()
            var ipAddressString = [CChar](repeating: 0, count: Int(INET6_ADDRSTRLEN))
            var storage         = self.storage
            
            withUnsafePointer(to: &storage) {
                $0.withMemoryRebound(to: sockaddr_in6.self, capacity: 1) {
                    addr6 = $0.pointee
                }
            }
            
            inet_ntop(AF_INET6, &addr6.sin6_addr, &ipAddressString, socklen_t(INET6_ADDRSTRLEN))
            return String(validatingUTF8: ipAddressString)
            
        default :
            return nil
        }
    }
    
    private static func equal(_ lhs: sockaddr_storage, _ rhs: sockaddr_storage) -> Bool
    {
        // TODO: hack
        var _lhs = lhs
        var _rhs = rhs
        
        if lhs.ss_family == rhs.ss_family {
            switch Int32(lhs.ss_family) {
            case AF_INET :
                var lhsAddr4 = sockaddr_in()
                var rhsAddr4 = sockaddr_in()
                
                withUnsafePointer(to: &_lhs) { $0.withMemoryRebound(to: sockaddr_in.self, capacity: 1) { lhsAddr4 = $0.pointee } }
                withUnsafePointer(to: &_rhs) { $0.withMemoryRebound(to: sockaddr_in.self, capacity: 1) { rhsAddr4 = $0.pointee } }
                
                return equal(lhsAddr4, rhsAddr4)
                
            case AF_INET6 :
                var lhsAddr6 = sockaddr_in6()
                var rhsAddr6 = sockaddr_in6()
                
                withUnsafePointer(to: &_lhs) { $0.withMemoryRebound(to: sockaddr_in6.self, capacity: 1) { lhsAddr6 = $0.pointee } }
                withUnsafePointer(to: &_rhs) { $0.withMemoryRebound(to: sockaddr_in6.self, capacity: 1) { rhsAddr6 = $0.pointee } }
                
                return equal(lhsAddr6, rhsAddr6)
                
            default :
                break
            }
        }
        
        return false
    }
    
    private static func equal(_ lhs: sockaddr_in, _ rhs: sockaddr_in) -> Bool
    {
        return lhs.sin_addr.s_addr == rhs.sin_addr.s_addr
    }
    
    private static func equal(_ lhs: sockaddr_in6, _ rhs: sockaddr_in6) -> Bool
    {
        let r = lhs.sin6_addr.__u6_addr.__u6_addr32.0 == rhs.sin6_addr.__u6_addr.__u6_addr32.0 &&
            lhs.sin6_addr.__u6_addr.__u6_addr32.1 == rhs.sin6_addr.__u6_addr.__u6_addr32.1 &&
            lhs.sin6_addr.__u6_addr.__u6_addr32.2 == rhs.sin6_addr.__u6_addr.__u6_addr32.2 &&
            lhs.sin6_addr.__u6_addr.__u6_addr32.3 == rhs.sin6_addr.__u6_addr.__u6_addr32.3
        
        return r
    }
    
}


// End of File
