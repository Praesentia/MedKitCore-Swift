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
    
    public var identifier   : UUID   { return _identifier; }
    public var manufacturer : String { return _manufacturer; }
    public var name         : String { return _name; }
    public var model        : String { return _model; }
    public var serialNumber : String { return _serialNumber; }
    public var type         : UUID   { return _type; }
    
    // MARK: - Shadowed
    private lazy var _identifier   : UUID = { return self.generateIdentifier(); }();
    private var      _manufacturer : String;
    private var      _name         : String;
    private var      _model        : String;
    private var      _serialNumber : String;
    private var      _type         : UUID;
    
    // TXT key constants
    private static let TXTKeyManufacturer = "mf";
    private static let TXTKeyModel        = "md";
    private static let TXTKeyName         = "dn";
    private static let TXTKeySerialNumber = "sn";
    private static let TXTKeyType         = "dt";
    
    /**
     Initialize instance from profile.
     
     - Parameters:
        - profile:
     */
    public init(from profile: JSON)
    {
        _manufacturer = profile[KeyManufacturer].string!;
        _model        = profile[KeyModel].string!;
        _name         = profile[KeyName].string!;
        _serialNumber = profile[KeySerialNumber].string!;
        _type         = deviceType(named: profile[KeyType].string!);
    }
    
    /**
     Initialize instance from TXT dictionary.
     
     - Parameters:
        - txt: Dictionary of key/value pairs derived from an associated TXT
               record, conforming to the MIST service type, version 1.
     */
    init(fromTXT txt: [String : String])
    {
        _manufacturer = txt[DeviceInfo.TXTKeyManufacturer]!;
        _model        = txt[DeviceInfo.TXTKeyModel]!;
        _name         = txt[DeviceInfo.TXTKeyName]!;
        _serialNumber = txt[DeviceInfo.TXTKeySerialNumber]!;
        _type         = deviceType(named: txt[DeviceInfo.TXTKeyType]!);
    }
    
    /**
     Generates a type 5 UUID for the device.
     */
    private func generateIdentifier() -> UUID
    {
        let sha1 = SecurityManagerShared.main.digest(using: .SHA1);
        
        sha1.update(uuid:           UUIDNSDevice);
        sha1.update(prefixedString: manufacturer);
        sha1.update(prefixedString: model);
        sha1.update(prefixedString: serialNumber);
        
        return UUID(fromSHA1: sha1.final());
    }
    
}


// End of File
