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


import Foundation


/**
 Device type.
 */
public class DeviceType {
    
    // MARK: - Properties
    
    /**
     Device type identifier.
     
     A type 5 UUID derived from the device type name.
     */
    public private(set) lazy var identifier: UUID = DeviceType.identifier(from: self.name)
    
    /**
     Device type name.
     */
    public let name: String

    /**
     Normalized device type name.
     
     Lower-cased version of device name.
     */
    public var normalizedName: String { return name.lowercased() }
    
    /**
     Localized description for the device type.
     */
    public var localizedDescription: String { return DeviceType.localizedDescriptions[normalizedName] ?? name }
    
    // MARK: - Initializers
    
    /**
     Initialize instance.
     
     Initializes the DeviceType from it's string representation.
     
     The name should preferrably be in cased form, as the name will be used as
     a default for the localized description.
     
     - Parameters:
        - name: String representation of the device type.
     */
    public init(named name: String)
    {
        self.name = name
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
        let digest = SecurityManagerShared.main.digest(using: .sha1)
        
        digest.update(uuid: UUIDNSDeviceType)
        digest.update(string: name.lowercased())
        
        return UUID(fromSHA1: digest.final())
    }
    
    /**
     Localizable string representation for device types.
     */
    static let localizedDescriptions = [
        "other"               : NSLocalizedString("Other",               comment: "Device type description."),
        "bridge"              : NSLocalizedString("Bridge",              comment: "Device type description."),
        "electrocardiograph"  : NSLocalizedString("Electrocardiograph",  comment: "Device type description."),
        "endoscope"           : NSLocalizedString("Endoscope",           comment: "Device type description."),
        "patient simulator"   : NSLocalizedString("Patient Simulator",   comment: "Device type description."),
        "pulse oximeter"      : NSLocalizedString("Pulse Oximeter",      comment: "Device type description."),
        "respiration monitor" : NSLocalizedString("Respiration Monitor", comment: "Device type description."),
        "sphygmograph"        : NSLocalizedString("Sphygmograph",        comment: "Device type description."),
        "sphygmomanometer"    : NSLocalizedString("Sphygmomanometer",    comment: "Device type description."),
        "thermometer"         : NSLocalizedString("Thermometer",         comment: "Device type description.")
    ]
    
}

/**
 Type 5 UUID representation for the device types.
 */
public let DeviceTypeBridge             = DeviceType.identifier(from: "Bridge")
public let DeviceTypeElectrocardiograph = DeviceType.identifier(from: "Electrocardiograph")
public let DeviceTypeEndoscope          = DeviceType.identifier(from: "Endoscope")
public let DeviceTypeOther              = DeviceType.identifier(from: "Other")
public let DeviceTypePatientSimulator   = DeviceType.identifier(from: "Patient Simulator")
public let DeviceTypePulseOximeter      = DeviceType.identifier(from: "Pulse Oximeter")
public let DeviceTypeRespirationMonitor = DeviceType.identifier(from: "Respiration Monitor")
public let DeviceTypeSphygmograph       = DeviceType.identifier(from: "Sphygmograph")
public let DeviceTypeSphygmomanometer   = DeviceType.identifier(from: "Sphygmomanometer")
public let DeviceTypeThermometer        = DeviceType.identifier(from: "Thermometer")



// End of File
