/*
 -----------------------------------------------------------------------------
 This source file is part of MedKitCore.
 
 Copyright 2017 Jon Griffeth
 
 Licensed under the Apache License, Version 2.0 (the "License")
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


public class WaveformStreamCache {
    
    public static let main = WaveformStreamCache()
    
    private struct Entry {
        unowned let reader: WaveformReader
        
        init(_ reader: WaveformReader)
        {
            self.reader = reader
        }
    }
    
    private var cache = [UUID : Entry]()
    
    /**
     Initialize instance.
     */
    private init()
    {
    }
    
    /**
     Find or instantiate a waveform reader for resource.
     */
    public func findReader(for resource: Resource) -> WaveformReader?
    {
        var reader = cache[resource.identifier]?.reader
        
        if reader == nil {
            reader = WaveformReader(from: resource)
            cache[resource.identifier] = Entry(reader!)
        }
        
        return reader
    }
    
    public func removeReader(with identifier: UUID)
    {
        cache[identifier] = nil
    }
    
}


// End of File
