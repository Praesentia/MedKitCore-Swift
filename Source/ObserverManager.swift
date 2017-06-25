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
 Observer Manager

 TODO: This needs work...
 */
public class ObserverManager<T> {
    
    // MARK: - Properties
    
    /**
     The number of observers registered with the manager.
     */
    public var count: Int { return observers.count }
    
    // MARK: - Private
    private var observers = [Weak]()
    
    // MARK: - Initializers
    
    /**
     Initialize instance.
     */
    public init()
    {
    }
    
    // MARK: - Mutators
    
    /**
     Add delegate.
     
     Add a delegate to the collection.
     */
    public func add(_ observer: T)
    {
        let x = observer as AnyObject
        
        assert(!contains(x))

        if !observers.contains(where: { $0.value === x }) {
            observers.append(Weak(x))
        }
    }
    
    /**
     Remove observer.
     
     Remove a observer from the collection.
     */
    public func remove(_ observer: AnyObject)
    {
        assert(contains(observer))
        
        if let index = observers.index(where: { $0.value === observer }) {
            observers.remove(at: index)
        }
    }
    
    /**
     Is the observer registered with the manager?
     */
    public func contains(_ observer: AnyObject) -> Bool
    {
        return observers.contains(where: { $0.value === observer })
    }
    
    /**
     Iterate over observers.
     
     Iterate over the collection, calling the handler for each observer.
     
     - Parameters:
        - handler:
     */
    public func withEach(handler: ((T) -> Void))
    {
        for observer in observers {
            if let x = observer.value as? T {
                handler(x)
            }
            else {
                debugPrint("Dangling reference")
            }
        }
    }
    
}


// End of File
