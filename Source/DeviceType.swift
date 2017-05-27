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
 Device type identifier.
 
 Calculates a type 5 UUID for a device type with the specified name.  The name
 is case-insensitive.
 */
public func deviceType(named name: String) -> UUID
{
    let digest = SecurityManagerShared.main.digest(using: .SHA1);
    
    digest.update(uuid: UUIDNSDeviceType);
    digest.update(string: name.lowercased());
    
    return UUID(fromSHA1: digest.final());
}

public func deviceTypeName(with identifier: UUID) -> String?
{
    return deviceTypeNames[identifier];
}

/**
 Type 5 UUID representation for the device types.
 */
public let DeviceTypeBridge             = deviceType(named: "Bridge");
public let DeviceTypeElectrocardiograph = deviceType(named: "Electrocardiograph");
public let DeviceTypeEndoscope          = deviceType(named: "Endoscope");
public let DeviceTypeOther              = deviceType(named: "Other");
public let DeviceTypePatientSimulator   = deviceType(named: "Patient Simulator");
public let DeviceTypePulseOximeter      = deviceType(named: "Pulse Oximeter");
public let DeviceTypeRespirationMonitor = deviceType(named: "Respiration Monitor");
public let DeviceTypeSphygmograph       = deviceType(named: "Sphygmograph");
public let DeviceTypeSphygmomanometer   = deviceType(named: "Sphygmomanometer");
public let DeviceTypeThermometer        = deviceType(named: "Thermometer");

/**
 String representation for the device types.
 */
let deviceTypeNames = [
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


// End of File
