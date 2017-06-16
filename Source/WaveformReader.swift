/*
 -----------------------------------------------------------------------------
 This source file is part of MedKitCore.
 
 Copyright 2017 Jon Griffeth
 
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


public class WaveformReader: ResourceObserver {
    
    // MARK: - Properties
    public let resource: Resource
    public let stream  = WaveformStream()
    
    // MARK: - Private Properties
    private var count: Int = 0
    
    // MARK: - Initialiers
    
    /**
     Initialize instance.
     */
    public init(from resource: Resource)
    {
        self.resource = resource
    }
    
    deinit
    {
        assert(count == 0)
        
        WaveformStreamCache.main.removeReader(with: resource.identifier)
    }
    
    public func start(completionHandler completion: @escaping (Error?) -> Void)
    {
        let sync = Sync()
        
        assert(count >= 0)
        
        count += 1
        if count == 1 {
            sync.incr()
            resource.addObserver(self) { error in
                sync.decr(error)
            }
        }
        
        sync.close(completionHandler: completion)
    }
    
    public func stop(completionHandler completion: @escaping (Error?) -> Void)
    {
        let sync = Sync()
        
        assert(count > 0)
        
        count -= 1
        if count == 0 { // TODO: race?
            sync.incr()
            resource.removeObserver(self) { error in
                sync.decr(error)
            }
        }
        
        sync.close(completionHandler: completion)
    }
    
    // MARK: - Private
    
    /**
     Decode 16-bit waveform data from base64 string.
     */
    private func decode16BitWaveformData(base64Encoded string: String, scale: Float) -> [Float]?
    {
        var data: [Float]!
        
        if let bytes  = Data(base64Encoded: string) {
            data = [Float]()
            
            var array = bytes.withUnsafeBytes {
                Array(UnsafeBufferPointer<Int16>(start: $0, count: bytes.count / MemoryLayout<Int16>.size));
            }
            
            for i in 0..<array.count {
                data.append(Float(Int16(bigEndian: array[i])) * scale);
            }
        }
        
        return data
    }
    
    // MARK: - ResourceObserver
    
    /**
     Resource update handler.
     
     TODO: hardcoded for 16-bit and scaling factor
     */
    public func resourceDidUpdate(_ resource: Resource)
    {
        if let value = resource.cache?.value, let string = value[KeyMeasurement].string {
            if let data = decode16BitWaveformData(base64Encoded: string, scale: 0.01) {
                stream.append(data: data, at: Int64(value[KeyIndex].double!));
            }
        }
    }
    
}


// End of File
