/*
 -----------------------------------------------------------------------------
 This source file is part of MedKitCore.

 Copyright 2018 Jon Griffeth

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


import SecurityKitAOS
import XCTest
@testable import MedKitCore


class DeviceIdentityTests: XCTestCase {

    private let deviceIdentifier : UUID = UUID(uuidString: "00D5A3E7-6294-5BBD-9723-58779D81C78D")!
    private var deviceIdentity   : DeviceIdentity!
    private let deviceTXT        = [ "mf" : "Acme Corporation", "md" : "Giant Mouse Trap", "sn" : "GMT-0001" ]

    override func setUp()
    {
        SecurityKitAOS.initialize()

        var deviceIdentity = DeviceIdentity()

        deviceIdentity.manufacturer = "Acme Corporation"
        deviceIdentity.model        = "Giant Mouse Trap"
        deviceIdentity.serialNumber = "GMT-0001"

        self.deviceIdentity = deviceIdentity
    }

    func testEquatable() throws
    {
        let lhs: DeviceIdentity = deviceIdentity
        var rhs: DeviceIdentity = deviceIdentity

        XCTAssertEqual(lhs, rhs)

        rhs.manufacturer = "acme corporation"

        XCTAssertNotEqual(lhs, rhs)
    }

    func testIdentifier() throws
    {
        XCTAssertEqual(deviceIdentifier, deviceIdentity.identifier)
    }

    func testTXTDecoding() throws
    {
        let decoder = TXTDecoder(from: deviceTXT)
        let result  = try DeviceIdentity(from: decoder)

        XCTAssertEqual(deviceIdentity, result)
    }

    func testCoding() throws
    {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data   = try encoder.encode(deviceIdentity)
        let result = try decoder.decode(DeviceIdentity.self, from: data)

        XCTAssertEqual(deviceIdentity, result)
    }

}


// End of File

