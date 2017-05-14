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


public let UnitTypeBeatsPerMinute       = UUID(uuidString: "c2e811aa-6550-4828-bcb7-c3c723f74cbc")!; // final
public let UnitTypeBreathsPerMinute     = UUID(uuidString: "b8e540a0-d5b5-4b62-8359-159fd7dbee87")!; // final
public let UnitTypeCelsius              = UUID(uuidString: "7983a868-b69f-4dbf-b5cd-19b6da94bc20")!; // final
public let UnitTypeFahrenheit           = UUID(uuidString: "f8ded7db-1ee1-4093-8199-2e557abe13c9")!; // final
public let UnitTypeMillilitersPerMinute = UUID(uuidString: "538ebec8-6183-4a08-9088-55ae911a2ced")!; // final
public let UnitTypeMillivolt            = UUID(uuidString: "303cf4c1-fbac-4d8d-8aae-e30bc39ff87a")!; // final
public let UnitTypeMMHg                 = UUID(uuidString: "e47d1de9-6e00-4430-9358-8d506d7607b8")!; // final
public let UnitTypePercent              = UUID(uuidString: "e9d5a99f-c8a3-405d-acda-8e7fd42a9925")!; // final
public let UnitTypeUnitless             = UUID(uuidString: "28641491-f46b-4cf9-989f-fbfed93c48a7")!; // final

public func unitLocalizedDescription(_ unitType: UUID) -> String?
{
    return unitTypeLocalization[unitType];
}

let unitTypeLocalization = [
    UnitTypeBeatsPerMinute       : "bpm",
    UnitTypeBreathsPerMinute     : "bpm",
    UnitTypeCelsius              : "°C",
    UnitTypeFahrenheit           : "°F",
    UnitTypeMillilitersPerMinute : "mL/min",
    UnitTypeMillivolt            : "mV",
    UnitTypeMMHg                 : "mmHg",
    UnitTypePercent              : "%",
    UnitTypeUnitless             : ""
]


// End of File
