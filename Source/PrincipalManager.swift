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
 Principal manager.
 */
public class PrincipalManager {
    
    // MARK: - Class Properties
    public static let main = PrincipalManager();
    
    // MARK: - Properties
    public var primary : Principal? { return _primary; }
    
    // MARK: - Shadowed
    private var _primary: Principal?;
    
    // MARK: - Private
    private var observers = ObserverManager<PrincipalManagerObserver>();
    
    // MARK: - Initializers
    
    /**
     Initialize instance.
     */
    private init()
    {
    }
    
    // MARK: - Observer Interface
    
    /**
     Add observer.
     */
    public func addObserver(_ observer: PrincipalManagerObserver)
    {
        observers.add(observer);
    }
    
    /**
     Remove observer.
     */
    public func removeObserver(_ observer: PrincipalManagerObserver)
    {
        observers.remove(observer);
    }
    
    // MARK: - Mutators
    
    /**
     Update primary principal.
     */
    public func updatePrimary(_ principal: Principal?)
    {
        _primary = principal;
        observers.withEach { $0.principalManagerDidUpdatePrimary(self); }
    }
    
}


// End of File
