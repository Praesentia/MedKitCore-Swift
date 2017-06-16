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


import Foundation;


public class WaveformStream: WaveformSource {
    
    // MARK: - Types
    public typealias Index = WaveformSource.Index;
    
    // MARK: - Properties
    public private(set) var cache      = [Float]()
    public private(set) var history    : TimeInterval = 30
    public private(set) var latency    : TimeInterval = 0
    public var              min        : Float?       { calcMinMax(); return _min; }
    public var              max        : Float?       { calcMinMax(); return _max; }
    public private(set) var offset     : Index = 0
    public private(set) var resolution : Float = 250
    
    // MARK: - Shadowed Properties
    private var _min       : Float?;
    private var _max       : Float?;
    
    // MARK: - Private Properties
    private var capacity   : Int;
    private var stale      : Bool  = true;
    
    /**
     Initialize instance.
     */
    public init()
    {
        capacity = Int(history * TimeInterval(resolution))
    }
    
    /**
     Append data.
     */
    public func append(data segment: [Float], at index: Int64)
    {
        updateLatency(for: TimeInterval(index) / TimeInterval(resolution));
        
        if cache.isEmpty {
            offset = index;
        }
        
        if index != end {
            debugPrint("discontinuity \(index - end)"); // TODO
        }
        
        cache += segment;
        stale  = true;
        
        if cache.count > capacity {
            let n = cache.count - capacity;
            
            cache.removeFirst(n);
            offset += Int64(n);
        }
    }
    
    /**
     Update latency.
     */
    private func updateLatency(for time: TimeInterval)
    {
        let now     = Date.timeIntervalSinceReferenceDate;
        let latency = now - time;
        
        self.latency = latency;
    }
    
    private func calcMinMax()
    {
        if stale {
            _min = nil;
            _max = nil;
            
            for i in 0..<cache.count {
                if _min == nil || cache[i] < _min! {
                    _min = cache[i];
                }
                if _max == nil || cache[i] > _max! {
                    _max = cache[i];
                }
            }
            
            stale = false;
        }
    }
    
}


// End of File
