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


public enum InetProto: Int {
    case tcp = 0
    case udp = 1
}

public extension InetProto {
    
    // MARK: - Properties
    public var inet: Int32 { return InetProto.codes[rawValue]; }
    
    // MARK: - Private Constants
    private static let codes = [ SOCK_STREAM, SOCK_DGRAM ];
    
    // MARK: - Initializers
    
    public init?(inet: Int32)
    {
        if let code = InetProto.codes.index(of: inet) {
            self.init(rawValue: code);
        }
        else {
            return nil;
        }
    }

}


// End of File
