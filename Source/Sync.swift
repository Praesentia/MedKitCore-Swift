/*
 -----------------------------------------------------------------------------
 This source file is part of MedKitCore.
 
 Copyright 2015-2017 Jon Griffeth
 
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


public typealias Sync = SyncT<Error>

/**
 Sync
 
 Used to synchronize multiple asynchronous calls.
 */
public class SyncT<Result> {
    
    // MARK: - Properties
    public private(set) var error: Result?
    
    // MARK: - Private Properties
    private var completion : ((Result?) -> Void)!
    private var count      : Int = 1
    
    /**
     Initialize instance.
     */
    public init()
    {
    }
    
    /**
     Initialize instance with error.
     */
    public init(_ error: Result?)
    {
        self.error = error
    }
    
    /**
     Clear
     
     Clear the current error.
     */
    public func clear()
    {
        self.error = nil
    }
    
    /**
     Fail
     
     Used to set or clear the current error.
     */
    public func fail(_ error: Result?)
    {
        self.error = error
    }
    
    /**
     Decrement the synchronization count.
     */
    public func decr(_ error: Result?)
    {
        assert(count > 0)
        
        if self.error == nil {
            self.error = error
        }
        
        decrAndExecute()
    }
    
    /**
     Increment the synchronization count.
     */
    public func incr()
    {
        assert(count > 0)
        
        count += 1
    }
    
    /**
     Finished
     */
    public func close(completionHandler completion: @escaping (Result?) -> Void)
    {
        assert(count > 0)
        
        self.completion = completion
        decrAndExecute()
    }
    
    /**
     Test And Execute
     
     Test whether or not synchronization has completed and calls the
     completion handler if it has.
     */
    private func decrAndExecute()
    {
        count -= 1
        if count == 0 {
            assert(completion != nil)
            completion(error)
        }
    }
    
}


// End of File
