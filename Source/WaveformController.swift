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
 Waveform controller.
 
 A waveform controller is used to access and control a waveform source stream.
 */
public protocol WaveformController: class {
    
    // MARK: - Properties
    
    /**
     Waveform controller delegate.
     */
    weak var delegate: WaveformControllerDelegate? { get set }
    
    /**
     Waveform source.
     
     The waveform source object used to access the waveform stream.  The
     property will be nil until waveform capture has been successfully
     initiated after invoking the start() method.
     */
    var source: WaveformSource? { get }
    
    // MARK: - Controls
    
    /**
     Start waveform capture.
     
     If successful, the waveformControllerDidStart() method on the delegate
     will be called.   At that time, the source property may be used to access
     the data stream.
     
     On failure, the waveformController(_:didStopForReason:) method will called
     with a reason for the failure.
     */
    func start()
    
    /**
     Stop waveform capture.
     */
    func stop()
    
}


// End of File
