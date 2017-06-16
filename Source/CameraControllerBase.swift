/*
 -----------------------------------------------------------------------------
 This source file is part of MedKitCore.
 
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


import Foundation;


/**
 Placeholder
 */
class CameraControllerBase: CameraController {
    
    // MARK: - Properties
    weak var         delegate : CameraControllerDelegate?
    private(set) var source   : CameraSource?
    
    // MARK: Private Properties
    private let resource: Resource
    
    // MARK: Initializers
    
    init(resource: Resource)
    {
        self.resource = resource
    }
    
    // MARK: - Control
    
    public func start()
    {
        stopped(for: MedKitError.NotSupported)
    }
    
    public func stop()
    {
    }
    
    private func stopped(for reason: Error?)
    {
        if let delegate = self.delegate {
            DispatchQueue.main.async {
                delegate.cameraController(self, didStopForReason: reason)
            }
        }
    }

}


// End of File
