/*
 -----------------------------------------------------------------------------
 This source file is part of MedKitCore.

 Copyright 2018 Jon Griffeth.  All rights reserved.
 -----------------------------------------------------------------------------
 */


import Foundation


public extension NetService {

    public func setTXTRecord(from encodable: TXTEncodable) throws
    {
        let encoder = TXTEncoder()

        try encodable.encode(to: encoder)
        setTXTRecord(encoder.data)
    }

}


// End of File
