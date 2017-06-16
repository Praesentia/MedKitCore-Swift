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


/**
 Waveform data source.
 */
public protocol WaveformSource: class {
    
    typealias Index = Int64
    
    /**
     A queue of cached waveform data.  New data is append to the end of the
     queue.  Earlier data, that has exceeded the retention time (see history),
     will be dropped from the head of the queue.
     */
    var cache: [Float] { get }
    
    /**
     Amount of data that will be retained in the cache, as a measure of time.
     */
    var history: TimeInterval { get }
    
    /**
     The latency on the capture stream.  The quality of this metric depends on
     how closely the clocks are in sync between the client and server devices.
     */
    var latency: TimeInterval { get }
    
    var min: Float? { get }
    var max: Float? { get }
    
    /**
     This value represents the time index for the first data element in the
     cache.  The value is updated whenever data is removed from the head of the
     cache.
     */
    var offset: Index { get }
    
    /**
     The number of data points per seconds.  This value will not change once
     established by the data source.
     */
    var resolution: Float { get }
    
}

public extension WaveformSource {
    
    public var count   : Int   { return cache.count }
    public var end     : Index { return offset + Int64(cache.count) }
    public var isEmpty : Bool  { return cache.isEmpty }
    
    public func inBounds(_ index: Index) -> Bool { return index >= offset && index < end }
    
    public subscript(_ index: Index) -> Float
    {
        return value(at: index) ?? 0
    }
    
    /**
     Value at index.
     */
    public func value(at index: Index) -> Float?
    {
        return inBounds(index) ? cache[Int(index - offset)] : nil
    }
    
}


// End of File
