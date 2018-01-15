/*
 -----------------------------------------------------------------------------
 This source file is part of MedKitCore.
 
 Copyright 2016-2018 Jon Griffeth
 
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


import Foundation
import SecurityKit


/**
 Protocol mode of operation.
 
 Specifies the mode of operation for various components in a protocol stack.
 */
public enum ProtocolMode {
    case client // Client-side mode of operation.
    case server // Server-side mode of operation.
}

public extension ProtocolMode {

    var tlsMode: TLSMode {
        switch self {
        case .client :
            return .client

        case .server :
            return .server
        }
    }

}


// End of File
