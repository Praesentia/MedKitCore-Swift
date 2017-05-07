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
 Resource Backend Delegate
 */
public protocol ResourceBackendDelegate: class {
    
    func resourceEnableNotification(_ resource : ResourceBackend, completionHandler completion : @escaping (ResourceCache?, Error?) -> Void);
    func resourceDisableNotification(_ resource : ResourceBackend, completionHandler completion : @escaping (Error?) -> Void);
    func resourceReadValue(_ resource : ResourceBackend, completionHandler completion : @escaping (ResourceCache?, Error?) -> Void);
    func resourceWriteValue(_ resource : ResourceBackend, _ value: JSON?, completionHandler completion : @escaping (ResourceCache?, Error?) -> Void);
    
}


// End of File
