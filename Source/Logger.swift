/*
 -----------------------------------------------------------------------------
 This source file is part of MedKit Device Simulator.
 
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


import Foundation


/**
 Logger
 */
public class Logger {
    
    public static let main = Logger()
    
    public weak var dataTap: DataTap?
    
    public func log(message: String)
    {
        if let dataTap = self.dataTap {
            let data = message.data(using: .utf8)!
            dataTap.dataTap(self, willSend: data, decoderFactory: DataDecoderDefaultFactory.main)
        }
    }
    
}


// End of File
