/*
 -----------------------------------------------------------------------------
 This source file is part of MedKitCore.
 
 Copyright 2017-2018 Jon Griffeth.  All rights reserved.
 -----------------------------------------------------------------------------
 */


import Foundation


public extension Date {

    static public let birthdateFormatter = DateFormatter(dateFormat: "yyyy-MM-dd", timeZone: TimeZone.current)
    
    var rfc3339: String { return Date.birthdateFormatter.string(from: self) }

    init(rfc3339: String) throws
    {
        if let date = Date.birthdateFormatter.date(from: rfc3339) {
            self = date
        }
        else {
            throw MedKitError.failed
        }
    }
    
}


// End of File
