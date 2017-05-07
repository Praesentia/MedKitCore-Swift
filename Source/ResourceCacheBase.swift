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
 ResourceCache implementation.
 
 Used to maintain a cached instance of the Resource value.
 */
public class ResourceCacheBase: ResourceCache {
    
    // MARK: - Properties
    public var json         : JSON         { return getJSON(); }
    public var timeModified : TimeInterval { return _timeModified; }
    public var value        : JSON?        { return _value; }
    
    // MARK: - Shadowed
    private var _timeModified : TimeInterval = 0;
    private var _value        : JSON?;
    
    // MARK: - Initializers
    
    /**
     Initialize instance.
     
     - Parameters:
        - value: The cache value.
        - time:  The modified time of the value.
     */
    public init(value: JSON?, at time: TimeInterval)
    {
        _timeModified = time;
        _value        = value;
    }
    
    /**
     Initialize instance from JSON.
     
     - Parameters:
        - json: JSON representation of the cache.
     */
    public init(from json: JSON)
    {
        _timeModified = Clock.convert(time: json[KeyTimeModified].time!);
        _value        = json[KeyValue];
    }
   
    /**
     Initialize instance.
     
     - Parameters:
        - cache: Cache from which to initialize the instance.
     */
    public init(from cache: ResourceCache)
    {
        _timeModified = cache.timeModified;
        _value        = cache.value;
    }
    
    // MARK: - JSON
    
    /**
     Generate JSON representation.
     
     - Returns: Returns a JSON representation of the cache.
     */
    private func getJSON() -> JSON
    {
        let result = JSON();
        
        result[KeyTimeModified] = Double(Clock.convert(time: timeModified));
        result[KeyValue]        = value;
        
        return result;
    }
    
    // MARK: - Updates
    
    /**
     */
    public func update(changes: JSON?, at time: TimeInterval)
    {
        _timeModified = time;
        _value        = changes;
    }
    
    /**
     */
    public func update(value: JSON?, at time: TimeInterval)
    {
        _timeModified = time;
        _value        = value;
    }
    
}


// End of File
