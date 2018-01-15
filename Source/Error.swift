/*
 -----------------------------------------------------------------------------
 This source file is part of MedKitCore.
 
 Copyright 2016-2018 Jon Griffeth
 
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
 MedKit Error
 
 Enumeration of MedKit error codes.
 */
public enum MedKitError: Int, Error, Codable, CustomStringConvertible, LocalizedError {
    case badArgs        =  1
    case badCredentials =  2
    case badMethod      =  3
    case badReply       =  4
    case duplicate      =  5
    case failed         =  6
    case notAuthorized  =  7
    case notFound       =  8
    case notImplemented =  9
    case notSignedIn    = 10
    case notSupported   = 11
    case protocolError  = 12
    case readOnly       = 13
    case rejected       = 14
    case suspended      = 15
    case unreachable    = 16
    case writeOnly      = 17
    
    public var description          : String  { return "MedKitError Code=\( rawValue )" }
    public var errorDescription     : String? { return MedKitError.localizedDescriptions[self] }
    public var localizedDescription : String? { return MedKitError.localizedDescriptions[self] }

}

extension MedKitError {

    /**
     Localizable description of error codes.
     */
    static let localizedDescriptions: [MedKitError : String] = [
        .badArgs        : NSLocalizedString("Bad arguments",         comment: "MedKit error description."),
        .badCredentials : NSLocalizedString("Bad credentials",       comment: "MedKit error description."),
        .badMethod      : NSLocalizedString("Bad method",            comment: "MedKit error description."),
        .badReply       : NSLocalizedString("Bad reply",             comment: "MedKit error description."),
        .duplicate      : NSLocalizedString("Duplicate",             comment: "MedKit error description."),
        .failed         : NSLocalizedString("Failed",                comment: "MedKit error description."),
        .notAuthorized  : NSLocalizedString("Not authorized",        comment: "MedKit error description."),
        .notFound       : NSLocalizedString("Not found",             comment: "MedKit error description."),
        .notImplemented : NSLocalizedString("Not implemented",       comment: "MedKit error description."),
        .notSignedIn    : NSLocalizedString("Not signed in",         comment: "MedKit error description."),
        .notSupported   : NSLocalizedString("Not supported",         comment: "MedKit error description."),
        .protocolError  : NSLocalizedString("Protocol error",        comment: "MedKit error description."),
        .readOnly       : NSLocalizedString("Read only",             comment: "MedKit error description."),
        .rejected       : NSLocalizedString("Rejected",              comment: "MedKit error description."),
        .suspended      : NSLocalizedString("Suspended",             comment: "MedKit error description."),
        .unreachable    : NSLocalizedString("Device is unreachable", comment: "MedKit error description."),
        .writeOnly      : NSLocalizedString("Write only",            comment: "MedKit error description.")
    ]
    
}


// End of File
