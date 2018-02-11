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


class DeviceInfoTests: XCTestCase {

    private var deviceIdentity : DeviceIdentity!
    private var deviceInfo     : DeviceInfo!
    private let deviceTXT      = [ "mf" : "Acme Corporation", "md" : "Giant Mouse Trap", "sn" : "GMT-0001", "dn" : "MyDevice", "dt" : "Rodent Control" ]

    override func setUp()
    {
        SecurityKitAOS.initialize()

        var deviceIdentity = DeviceIdentity()
        var deviceInfo     = DeviceInfo()

        deviceIdentity.manufacturer = "Acme Corporation"
        deviceIdentity.model        = "Giant Mouse Trap"
        deviceIdentity.serialNumber = "GMT-0001"

        deviceInfo.identity = deviceIdentity
        deviceInfo.name     = "MyDevice"
        deviceInfo.type     = DeviceType(named: "Rodent Control")

        self.deviceIdentity = deviceIdentity
        self.deviceInfo     = deviceInfo
    }

    func testIdentifier() throws
    {
        XCTAssertEqual(deviceIdentity.identifier, deviceInfo.identifier)
    }

    func testTXTDecoding() throws
    {
        let decoder = TXTDecoder(from: deviceTXT)
        let result  = try DeviceInfo(from: decoder)

        XCTAssertEqual(deviceInfo, result)
    }

    func testCoding() throws
    {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data   = try encoder.encode(deviceInfo)
        let result = try decoder.decode(DeviceInfo.self, from: data)

        XCTAssertEqual(deviceInfo, result)
    }

}


// End of File
