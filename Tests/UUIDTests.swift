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


import XCTest
@testable import MedKitCore


class UUIDTests: XCTestCase {

    func testLowercase()
    {
        let uuidString = "DDF2A1BC-AFE4-46FF-BA8F-76F3480B329B"
        let uuid       = UUID(uuidString: uuidString)!

        XCTAssertEqual(uuidString.lowercased(), uuid.uuidLowercase)
    }

    func testNull()
    {
        XCTAssertEqual("00000000-0000-0000-0000-000000000000", UUID.null.uuidString)
    }

}


// End of File
