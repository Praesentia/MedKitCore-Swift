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
 Device metadata.
 */
public class DeviceInfo {
    
    // MARK: - Properties
    public lazy var         identifier   : UUID = { return self.generateIdentifier(); }();
    public private(set) var manufacturer : String;
    public private(set) var name         : String;
    public private(set) var model        : String;
    public private(set) var serialNumber : String;
    public private(set) var type         : UUID;
    
    // MARK: - Private Constants
    private static let TXTKeyManufacturer = "mf";
    private static let TXTKeyModel        = "md";
    private static let TXTKeyName         = "dn";
    private static let TXTKeySerialNumber = "sn";
    private static let TXTKeyType         = "dt";
    
    // MARK: - Initializers
    
    /**
     Initialize instance from profile.
     
     - Parameters:
        - profile:
     */
    public init(from profile: JSON)
    {
        manufacturer = profile[KeyManufacturer].string!;
        model        = profile[KeyModel].string!;
        name         = profile[KeyName].string!;
        serialNumber = profile[KeySerialNumber].string!;
        type         = deviceType(named: profile[KeyType].string!);
    }
    
    /**
     Initialize instance from TXT dictionary.
     
     - Parameters:
        - txt: Dictionary of key/value pairs derived from an associated TXT
               record, conforming to the MIST service type, version 1.
     */
    init(fromTXT txt: [String : String])
    {
        manufacturer = txt[DeviceInfo.TXTKeyManufacturer]!;
        model        = txt[DeviceInfo.TXTKeyModel]!;
        name         = txt[DeviceInfo.TXTKeyName]!;
        serialNumber = txt[DeviceInfo.TXTKeySerialNumber]!;
        type         = deviceType(named: txt[DeviceInfo.TXTKeyType]!);
    }
    
    // MARK: - Identifier
    
    /**
     Generate a type 5 UUID for the device.
     */
    private func generateIdentifier() -> UUID
    {
        let digest = SecurityManagerShared.main.digest(using: .SHA1);
        
        digest.update(uuid:           UUIDNSDevice);
        digest.update(prefixedString: manufacturer);
        digest.update(prefixedString: model);
        digest.update(prefixedString: serialNumber);
        
        return UUID(fromSHA1: digest.final());
    }
    
}


// End of File
