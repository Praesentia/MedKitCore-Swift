/*
 -----------------------------------------------------------------------------
 This source file is part of MedKitCore.
 
 Copyright 2017 Jon Griffeth.  All rights reserved.
 -----------------------------------------------------------------------------
 */


import Foundation


public extension NSError {
    
    convenience init?(posix: Int32)
    {
        if posix != 0 {
            self.init(domain: NSPOSIXErrorDomain, code: Int(posix), userInfo: nil)
        }
        else {
            return nil
        }
    }
    
}


// End of File
