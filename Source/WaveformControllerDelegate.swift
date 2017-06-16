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
 WaveformController delegate.
 */
public protocol WaveformControllerDelegate: class {
    
    /**
     Waveform controller did start.
     
     This method is called in response to ...
     */
    func waveformControllerDidStart(_ waveformController: WaveformController)

    /**
     Waveform controller did stop.
     
     This method is called in response to waveform capture being interrupted
     for any reason.
     */
    func waveformController(_ waveformController: WaveformController, didStopForReason reason: Error?)

    /**
     Waveform controller did update latency.
     */
    func waveformControllerDidUpdateLatency(_ waveformController: WaveformController)
    
}


// End of File
