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
 WaveformController base class.
 */
class WaveformControllerBase: WaveformController {
    
    // MARK: - Properties
    public weak var delegate : WaveformControllerDelegate?
    public var      source   : WaveformSource? { return reader?.stream }
    
    // MARK: - Private Properties
    private var reader   : WaveformReader?
    private let resource : Resource
    
    // MARK: - Initializers
    
    init(resource: Resource)
    {
        self.resource = resource
    }
    
    // MARK: - Controls
    
    public func start()
    {
        guard(reader == nil) else { return }
        
        let sync = Sync()
        
        if let reader = WaveformStreamCache.main.findReader(for: resource) {
            sync.incr()
            reader.start() { error in
                if error == nil {
                    self.reader = reader
                }
                sync.decr(error)
            }
        }
        else {
            sync.fail(MedKitError.Failed)
        }
        
        sync.close() { error in
            if error == nil {
                self.started()
            }
            else {
                self.stopped(for: error)
            }
        }
    }
    
    public func stop()
    {
        if let reader = self.reader {
            reader.stop() { error in
                if error == nil {
                    self.reader = nil
                }
                self.stopped(for: error)
            }
        }
    }
    
    // MARK: - Private
    
    private func started()
    {
        if let delegate = self.delegate {
            DispatchQueue.main.async {
                delegate.waveformControllerDidStart(self)
            }
        }
    }
    
    private func stopped(for reason: Error?)
    {
        if let delegate = self.delegate {
            DispatchQueue.main.async {
                delegate.waveformController(self, didStopForReason: reason)
            }
        }
    }
    
}


// End of File
