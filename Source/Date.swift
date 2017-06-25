/*
 -----------------------------------------------------------------------------
 This source file is part of MedKitCore.
 
 Copyright 2017 Jon Griffeth.  All rights reserved.
 -----------------------------------------------------------------------------
 */


import Foundation


public extension Date {
    
    static private let BirthdateFormat = "yyyy-MM-dd"
    static private let dateFormatter   = DateFormatter()
    
    var rfc3339: String {
        Date.dateFormatter.dateFormat = Date.BirthdateFormat
        return Date.dateFormatter.string(from: self)
    }
    
    static func rfc3339(_ string: String) -> Date?
    {
        Date.dateFormatter.dateFormat = Date.BirthdateFormat
        return Date.dateFormatter.date(from: string)
    }
    
}


// End of File
