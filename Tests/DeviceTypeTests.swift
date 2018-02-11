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


class DeviceTypeTests: XCTestCase {

    override func setUp()
    {
        SecurityKitAOS.initialize()
    }

    func testIdentifier() throws
    {
        let deviceIdentifier = UUID(uuidString: "53B4AFF9-57F5-53D3-BABF-6218458CA774");
        let deviceType       = DeviceType(named: "Other")

        XCTAssertEqual(deviceIdentifier, deviceType.identifier)
        XCTAssertEqual("Other", deviceType.name)
    }

    func testCoding()
    {
        let deviceType = DeviceType(named: "Other")
        let encoder    = JSONEncoder()
        let decoder    = JSONDecoder()

        //let data   = try encoder.encode(deviceType)
        //let result = try decoder.decode(DeviceType.self, from: data)

        //XCTAssertEqual(deviceType, result)
    }

}


// End of File
