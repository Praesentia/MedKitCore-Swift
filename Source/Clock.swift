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


public typealias Time = Int64;

/**
 Clock
 
 Implements a MedKit compatible clock interface.
 */
public class Clock {
    
    public  static let Resolution : TimeInterval = 1000000;   //: microseconds
    private static let Offset     : TimeInterval = 978307200;
    
    public init()
    {
    }
    
    public class func convert(time: TimeInterval) -> Time
    {
        return Time((time + Clock.Offset) * Clock.Resolution);
    }
    
    public class func convert(time: Time) -> TimeInterval
    {
        return TimeInterval(time) / Clock.Resolution - Clock.Offset;
    }
    
    public class func getTime() -> TimeInterval
    {
        return Date.timeIntervalSinceReferenceDate;
    }

}


// End of File
