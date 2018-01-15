/*
 -----------------------------------------------------------------------------
 This source file is part of MedKitCore.
 
 Copyright 2017-2018 Jon Griffeth
 
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


import XCTest
@testable import MedKitCore


class ClockTests: XCTestCase {
    
    static let dateFormatter = ISO8601DateFormatter()
    
    let EpochPOSIX  = ClockTests.dateFormatter.date(from: "1970-01-01T00:00:00Z")!
    let EpochUTC    = ClockTests.dateFormatter.date(from: "1972-01-01T00:00:00Z")!
    let EpochMedKit = Time(63072000000000) // microseconds
    
    func testTimeConversions()
    {
        // TimeInterval to Time
        XCTAssertTrue(Clock.convert(time: EpochPOSIX.timeIntervalSinceReferenceDate) == 0)
        XCTAssertTrue(Clock.convert(time: EpochUTC.timeIntervalSinceReferenceDate)   == EpochMedKit)
        
        // Time to TimeInterval
        XCTAssertTrue(Clock.convert(time: 0)           == EpochPOSIX.timeIntervalSinceReferenceDate)
        XCTAssertTrue(Clock.convert(time: EpochMedKit) == EpochUTC.timeIntervalSinceReferenceDate)
    }
    
}


// End of File
