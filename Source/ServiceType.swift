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
 Service types.
 */
public let ServiceTypeDeviceInformation  = UUID(uuidString: "982e9ed2-9722-44f1-b954-2e38ce2f86ed")!; // final
public let ServiceTypeElectrocardiograph = UUID(uuidString: "323d0b9d-12b0-41b8-965a-98db654a0be7")!; // final
public let ServiceTypeEndoscope          = UUID(uuidString: "babe2430-a0fb-40ac-aad6-d95b7ca2eac3")!; // final
public let ServiceTypeOther              = UUID(uuidString: "60f3ef28-b920-4af6-859c-dcdfbf0249fe")!; // final
public let ServiceTypePatientSimulator   = UUID(uuidString: "502b999c-0fb9-4f60-96ce-b1db1e1ef309")!; // final
public let ServiceTypePulseOximeter      = UUID(uuidString: "a694d83f-dd2a-457f-bdba-ac38c3833f07")!; // final
public let ServiceTypeRespiration        = UUID(uuidString: "e43db823-f8cd-42ae-b05f-0fee33059667")!; // final
public let ServiceTypeSphygmograph       = UUID(uuidString: "7f6ead79-bf3c-4862-a52a-71e79ed69579")!; // final
public let ServiceTypeSphygmomanometer   = UUID(uuidString: "59b00761-4f41-4cd5-a32d-cdd3561ff1df")!; // final
public let ServiceTypeThermometer        = UUID(uuidString: "6b6f3ccc-20b6-4725-b5f1-360809e7dbe9")!; // final
public let ServiceTypeVitals             = UUID(uuidString: "a28e7dbf-0418-4dd0-b505-df75047781d1")!; // final

/**
 String representation for the service types.
 */
public let serviceTypeName = [
    ServiceTypeOther              : "Other",
    ServiceTypeDeviceInformation  : "Device Information",
    ServiceTypeElectrocardiograph : "Electrocardiograph",
    ServiceTypeEndoscope          : "Endoscope",
    ServiceTypePatientSimulator   : "Patient Simulator",
    ServiceTypePulseOximeter      : "Pulse Oximeter",
    ServiceTypeRespiration        : "Respiration",
    ServiceTypeSphygmograph       : "Sphygmograph",
    ServiceTypeSphygmomanometer   : "Sphygmomanometer",
    ServiceTypeThermometer        : "Thermometer",
    ServiceTypeVitals             : "Vitals"
];


// End of File
