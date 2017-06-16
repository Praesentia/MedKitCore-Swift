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


public class DeviceType {
    
    public let identifier           : UUID
    public var name                 : String? { return DeviceType.names[identifier] }
    public var localizedDescription : String  { return name ?? identifier.uuidstring }
    
    public init(with identifier: UUID)
    {
        self.identifier = identifier
    }
    
    public init(named name: String)
    {
        identifier = DeviceType.identifier(from: name)
    }
    
}

extension DeviceType {
    
    /**
     Device type identifier.
     
     Calculates a type 5 UUID for a device type with the specified name.  The name
     is case-insensitive.
     */
    class func identifier(from name: String) -> UUID
    {
        let digest = SecurityManagerShared.main.digest(using: .SHA1);
        
        digest.update(uuid: UUIDNSDeviceType);
        digest.update(string: name.lowercased());
        
        return UUID(fromSHA1: digest.final());
    }
    
    /**
     String representation for the device types.
     */
    static let names = [
        DeviceTypeOther              : "Other",
        DeviceTypeBridge             : "Bridge",
        DeviceTypeElectrocardiograph : "Electrocardiograph",
        DeviceTypeEndoscope          : "Endoscope",
        DeviceTypePatientSimulator   : "Patient Simulator",
        DeviceTypePulseOximeter      : "Pulse Oximeter",
        DeviceTypeRespirationMonitor : "Respiration Monitor",
        DeviceTypeSphygmograph       : "Sphygmograph",
        DeviceTypeSphygmomanometer   : "Sphygmomanometer",
        DeviceTypeThermometer        : "Thermometer"
    ];
    
}

/**
 Type 5 UUID representation for the device types.
 */
public let DeviceTypeBridge             = DeviceType.identifier(from: "Bridge");
public let DeviceTypeElectrocardiograph = DeviceType.identifier(from: "Electrocardiograph");
public let DeviceTypeEndoscope          = DeviceType.identifier(from: "Endoscope");
public let DeviceTypeOther              = DeviceType.identifier(from: "Other");
public let DeviceTypePatientSimulator   = DeviceType.identifier(from: "Patient Simulator");
public let DeviceTypePulseOximeter      = DeviceType.identifier(from: "Pulse Oximeter");
public let DeviceTypeRespirationMonitor = DeviceType.identifier(from: "Respiration Monitor");
public let DeviceTypeSphygmograph       = DeviceType.identifier(from: "Sphygmograph");
public let DeviceTypeSphygmomanometer   = DeviceType.identifier(from: "Sphygmomanometer");
public let DeviceTypeThermometer        = DeviceType.identifier(from: "Thermometer");



// End of File
