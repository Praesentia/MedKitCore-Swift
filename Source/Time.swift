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
 MedKit time value.
 
 MedKit time values are signed 64bit values representing the number of
 microseconds that have elapsed since UTC 1972-01-01T00:00:00 plus an offset of
 63,072,000 seconds.  The offset permits time values to be seconds compatible
 with Unix time.
 */
public typealias Time = Int64;


// End of File
