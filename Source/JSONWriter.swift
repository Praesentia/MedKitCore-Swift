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
 JSON writer.
 */
public class JSONWriter {
    
    /**
     Write JSON to string.
     
     - Parameters:
        - json
     */
    public class func write(json: JSON) -> String?
    {
        do {
            if let data = JSONConverter.externalize(json: json) {
                let data = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                return String(data: data, encoding: .utf8)
            }
            return nil
        }
        catch {
            return nil
        }
    }
    
}


// End of File
