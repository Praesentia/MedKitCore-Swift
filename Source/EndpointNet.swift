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
 Network endpoint.
 */
class EndpointNet: Endpoint {

    // MARK: - Properties
    var hostAddress : SockAddr? { return getHostAddress() }
    var peerAddress : SockAddr? { return getPeerAddress() }

    // MARK: - Private Constants
    private let InvalidSocket : Int32 = -1
    
    // MARK: - Private
    private var proto         : InetProto = .udp
    private var receiver      : DispatchSourceRead!
    private var receiverActive: Bool = false
    private var sender        : DispatchSourceWrite!
    private var senderActive  : Bool = false
    private var socket        : Int32 = -1
    
    // MARK: - Initializers/Deinitializers
    
    /**
     Initialize instance.
     */
    override init()
    {
    }
    
    /**
     Initialize instance from existing socket.
     
     - Parameters:
        - socket: The file descriptor for the socket.
        - proto:  The socket protocol.
     */
    init(socket: Int32, proto: InetProto)
    {
        self.socket = socket
        self.proto  = proto
        
        super.init()
        
        if fcntl(socket, F_SETFL, O_NONBLOCK) == 0 {
            instantiateDispatch()
        }
        else {
            // TODO
        }
    }
    
    /**
     Deinitialize instance.
     */
    deinit
    {
        close()
    }
    
    // MARK: -
    
    /**
     */
    override func shutdown()
    {
        close()
    }
    
    /**
     */
    func accept() -> EndpointNet?
    {
        guard(socket != InvalidSocket) else { return nil }
    
        var endpoint : EndpointNet?
        var storage  = sockaddr_storage()
        
        withUnsafeMutablePointer(to: &storage) { ptr in
            ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) { address in
                
                var client : Int32
                var len    = socklen_t(MemoryLayout<sockaddr_storage>.size)
                
                client = Foundation.accept(socket, address, &len)
                if client != InvalidSocket {
                    endpoint = EndpointNet(socket: client, proto: proto)
                }
                
            }
        }
        
        return endpoint
    }
    
    /**
     Close socket.
     */
    func close()
    {
        guard(socket != InvalidSocket) else { return }

        if let receiver = self.receiver {
            receiver.cancel()
            if !receiverActive {
                receiver.resume() // TODO
            }
            self.receiver = nil
        }
        
        if let sender = self.sender {
            sender.cancel()
            if !senderActive {
                sender.resume()
            }
            self.sender = nil
        }

        _ = Foundation.close(socket)
        socket = InvalidSocket
    }

    /**
     Connect
     */
    func connect(address: SockAddr) -> Bool
    {
        guard(socket == InvalidSocket) else { return false }
        
        var status : Int32 = -1
        
        if instantiate(address: address) {
            var storage = address.storage
            
            withUnsafePointer(to: &storage) { ptr in
                ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) { destination in

                    status = Foundation.connect(socket, destination, address.len)
                    if status != 0 {
                        switch errno {
                        case EINPROGRESS :
                            status = 0
                            resumeOut()
                            
                        default :
                            break // TODO: early connection?
                        }
                    }
                }
            }
            
        }
        
        return status == 0
    }
    
    /**
     Listen
     
     - Parameters:
        - address: The host address on which to listen.
        - backlog: The listener backlog.
     */
    func listen(address: SockAddr, backlog: Int32) -> Bool
    {
        guard(socket == InvalidSocket) else { return false }
        
        var status: Bool = false
        
        if instantiate(address: address) {
            if bind(address: address) {
                status = (Foundation.listen(socket, backlog) == 0)
            }
        }
        
        return status
    }
    
    /**
     Resume input.
     */
    override func resumeIn()
    {
        if !receiverActive {
            receiver.resume()
            receiverActive = true
        }
    }
    
    /**
     Resume input.
     */
    func suspendIn()
    {
        if !receiverActive {
            receiver.suspend()
            receiverActive = false
        }
    }
    
    /**
     Resume output.
     */
    override func resumeOut()
    {
        if !senderActive {
            sender.resume()
            senderActive = true
        }
    }
    
    /**
     Resume output.
     */
    func suspendOut()
    {
        if !senderActive {
            sender.suspend()
            senderActive = false
        }
    }
    
    /**
     Receive data.
     */
    func receive(_ data: inout Data) -> Int
    {
        guard(socket != InvalidSocket) else { return Endpoint.failed }
        
        var count = Int()
        
        data.withUnsafeMutableBytes { bytes in
            count = read(socket, bytes, data.count)
        }
        
        if count < 0 {
            switch errno {
            case EAGAIN :
                count = Endpoint.wouldBlock
                
            default :
                count = Endpoint.failed
            }
        }
        
        if count == 0 {
            count = Endpoint.closed
        }
        
        return count
    }
    
    /**
     Send data.
     */
    func send(_ data: Data) -> Int
    {
        guard(socket != InvalidSocket) else { return Endpoint.failed }
        
        var count = Int()
        
        data.withUnsafeBytes { bytes in
            count = write(socket, bytes, data.count)
        }
        
        if count < 0 {
            switch errno {
            case EAGAIN :
                count = Endpoint.wouldBlock
                
            default :
                count = Endpoint.failed
            }
        }
        
        if count == 0 {
            count = Endpoint.closed
        }
        
        return count
    }
    
    /**
     Bind socket.
     */
    private func bind(address: SockAddr) -> Bool
    {
        var status  : Int32 = -1
        var storage = address.storage
        
        withUnsafePointer(to: &storage) { ptr in
            ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) { local in
                status = Foundation.bind(socket, local, address.len)
            }
        }
        
        return status == 0
    }
    
    /**
     Instantiate socket.
     */
    private func instantiate(address: SockAddr) -> Bool
    {
        socket = Foundation.socket(address.address.family, address.proto.inet, 0)
        if socket != InvalidSocket {
            if setSocketOptions(socket) {
                proto = address.proto
                instantiateDispatchConnect()
            }
            else {
                _ = Foundation.close(socket) // TODO: check result
                socket = InvalidSocket
            }
        }
        
        return socket != InvalidSocket
    }
    
    /**
     Create socket.
     */
    private func setSocketOptions(_ socket: Int32) -> Bool
    {
        var option: Int32 = 1
        let len   = socklen_t(MemoryLayout<Int32>.size)
        
        if setsockopt(socket, SOL_SOCKET, SO_NOSIGPIPE, &option, len) != 0 {
            return false
        }
            
        if fcntl(socket, F_SETFL, O_NONBLOCK) != 0 {
            return false
        }
        
        return true
    }
    
    /**
     Connection callback.
     */
    private func connected()
    {
        var value = Int32()
        var len   = socklen_t(MemoryLayout<Int32>.size)
        var error : Error?
        
        suspendOut()
        
        let status = getsockopt(socket, SOL_SOCKET, SO_ERROR, &value, &len)
        
        if status == 0 {
            error = NSError(posix: value)
        }
        else {
            error = NSError(posix: errno)
        }
        
        if error == nil {
            sender.setEventHandler { [weak self] in self?.output() }
        }
        
        delegate?.endpointDidConnect(self, with: error)
    }
    
    /**
     Create dispatch sources for reading and writing.
     */
    private func instantiateDispatch()
    {
        receiver = DispatchSource.makeReadSource(fileDescriptor: socket, queue: DispatchQueue.main)
        receiver.setEventHandler { [weak self] in self?.input() }
        receiver.activate()
        suspendIn()
        
        sender = DispatchSource.makeWriteSource(fileDescriptor: socket, queue: DispatchQueue.main)
        sender.setEventHandler { [weak self] in self?.output() }
        sender.activate()
        suspendOut()
    }
    
    /**
     Create dispatch sources for reading and writing.
     */
    private func instantiateDispatchConnect()
    {
        receiver = DispatchSource.makeReadSource(fileDescriptor: socket, queue: DispatchQueue.main)
        receiver.setEventHandler { [weak self] in self?.input() }
        receiver.activate()
        suspendIn()
        
        sender = DispatchSource.makeWriteSource(fileDescriptor: socket, queue: DispatchQueue.main)
        sender.setEventHandler { [weak self] in self?.connected() }
        sender.activate()
        suspendOut()
    }
    
    /**
     Get host address.
     */
    private func getHostAddress() -> SockAddr?
    {
        var host: SockAddr?
        
        if socket != InvalidSocket {
            var storage = sockaddr_storage()
            
            withUnsafeMutablePointer(to: &storage) { ptr in
                ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) { address in
                    var len = storage.length
                    
                    if getsockname(socket, address, &len) == 0 {
                        host = SockAddr(proto: proto, address: storage)
                    }
                }
            }
        }
        
        return host
    }
    
    /**
     Get host address.
     */
    private func getPeerAddress() -> SockAddr?
    {
        var peer: SockAddr?
        
        if socket != InvalidSocket {
            var storage = sockaddr_storage()
            
            withUnsafeMutablePointer(to: &storage) { ptr in
                ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) { address in
                    var len = storage.length
                    
                    if getsockname(socket, address, &len) == 0 {
                        peer = SockAddr(proto: proto, address: storage)
                    }
                }
            }
        }
        
        return peer
    }
    
    /**
     Input callback.
     */
    private func input()
    {
        suspendIn()
        delegate?.endpointIn(self)
    }
    
    /**
     Output callback.
     */
    private func output()
    {
        suspendOut()
        delegate?.endpointOut(self)
    }
    
}


// End of File
