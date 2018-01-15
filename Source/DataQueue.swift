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
 Data queue.
 
 - Remark: Fairly simplistic implementation.
 */
public class DataQueue {
    
    // MARK: - Properties
    public var count   : Int  { return queue.count }
    public var isEmpty : Bool { return queue.isEmpty }
    
    // MARK: - Private Properties
    private var queue = [UInt8]()
    
    // MARK: - Initializers
    
    public init()
    {
    }
    
    // MARK: - Update
    
    public func append(_ data: Data)
    {
        queue += data
    }

    public func clear()
    {
        queue.removeAll()
    }

    // MARK: - Access
    
    public func peek(count: Int) -> [UInt8]
    {
        return Array<UInt8>(queue[0..<count])
    }
    
    public func read(count: Int) -> [UInt8]
    {
        let data = Array<UInt8>(queue[0..<count])
        
        queue.removeFirst(Int(count))
        return data
    }

    // MARK: - Search
    
    public func scan(for sequence: [UInt8]) -> Int?
    {
        if queue.count >= sequence.count {
            for i in 0...(queue.count - sequence.count) {
                if match(queue, i, sequence) {
                    return i + sequence.count
                }
            }
        }
        
        return nil
    }
    
    private func match(_ buffer: [UInt8], _ offset: Int, _ sequence: [UInt8]) -> Bool
    {
        for i in 0..<sequence.count {
            if sequence[i] != buffer[offset + i] {
                return false
            }
        }
        
        return true
    }
    
}


// End of File
