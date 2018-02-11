/*
 -----------------------------------------------------------------------------
 This source file is part of MedKitCore.

 Copyright 2018 Jon Griffeth.  All rights reserved.
 -----------------------------------------------------------------------------
 */


import Foundation


public extension Data {

    public init(base64 string: String) throws
    {
        let data = Data(base64Encoded: string)

        if data != nil {
            self = data!
        }
        else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Invalid base64 encoded string."))
        }
    }

}


// End of File
