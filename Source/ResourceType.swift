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


public class ResourceType {
    
    public let identifier           : UUID
    public var localizedDescription : String  { return ResourceType.localizedDescriptions[identifier] ?? identifier.uuidstring }
    
    public init(with identifier: UUID)
    {
        self.identifier = identifier
    }
    
}

extension ResourceType {
    
    /**
     Localized description for resource types.
     */
    static let localizedDescriptions = [
        ResourceTypeBloodOxygenSaturation         : "Blood Oxygen Saturation",
        ResourceTypeBloodOxygenSaturationWaveform : "Blood Oxygen Saturation",
        ResourceTypeBloodPressure                 : "Blood Pressure",
        ResourceTypeBloodPressureWaveform         : "Blood Pressure",
        ResourceTypeCamera                        : "Camera",
        ResourceTypeECGWaveform                   : "ECG",
        ResourceTypeLocation                      : "Location",
        ResourceTypePatient                       : "Patient",
        ResourceTypePerfusionIndex                : "Perfusion Index",
        ResourceTypePulseRate                     : "Pulse Rate",
        ResourceTypePulseRateAlert                : "Pulse Rate Alert",
        ResourceTypeRespirationRate               : "Respiration Rate",
        ResourceTypeRespirationWaveform           : "Respiration",
        ResourceTypeSkinTemperature               : "Skin Temperature",
        ResourceTypeSoftwareVersion               : "Software Version"
    ]
    
}

/**
 Resource types.
 */
public let ResourceTypeBloodOxygenSaturation         = UUID(uuidString: "1ba8c945-7195-4a2a-a875-0c98528eb637")!; // final
public let ResourceTypeBloodOxygenSaturationWaveform = UUID(uuidString: "64327018-5680-496a-bd0f-a523e2b53d58")!; // final
public let ResourceTypeBloodPressure                 = UUID(uuidString: "16ca57af-5f42-4008-a398-8a0917384e92")!; // final
public let ResourceTypeBloodPressureWaveform         = UUID(uuidString: "0b19732b-92bb-494f-841d-b3ead9c6bd05")!; // final
public let ResourceTypeCamera                        = UUID(uuidString: "7e470049-f3aa-4bda-98ac-ce980137488c")!; // final
public let ResourceTypeECGWaveform                   = UUID(uuidString: "1a4a6fe7-4882-4737-b61b-0291de47d8e6")!; // final
public let ResourceTypeLocation                      = UUID(uuidString: "41f42113-5ba2-44d2-a3f4-d062f7bec929")!; // final
public let ResourceTypePatient                       = UUID(uuidString: "2fa67527-c69c-473a-b1a5-f9fdaf83b97a")!; // final
public let ResourceTypePerfusionIndex                = UUID(uuidString: "9d2b38b7-d170-4c0a-b76e-01177d79cc71")!; // final
public let ResourceTypePulseRate                     = UUID(uuidString: "38948d8b-5d14-4c56-b77b-70813aa6404f")!; // final
public let ResourceTypePulseRateAlert                = UUID(uuidString: "a273ebda-cfd2-41af-b111-67bb07c9be7f")!; // final
public let ResourceTypeRespirationRate               = UUID(uuidString: "23adef66-a104-4aee-b6b5-044a7b7707a5")!; // final
public let ResourceTypeRespirationWaveform           = UUID(uuidString: "e4775c0a-ce89-4eb0-b0fc-986e583b5530")!; // final
public let ResourceTypeSkinTemperature               = UUID(uuidString: "580e291e-5637-47c7-8931-66812d107b0a")!; // final
public let ResourceTypeSoftwareVersion               = UUID(uuidString: "2539cb22-2c7b-4a88-96ec-a189f2d0b28d")!; // final



// End of File
