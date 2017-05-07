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


import Foundation;


/**
 MedKit Error
 
 Enumerates the MedKit errors.
 */
public enum MedKitError : Int, Error, CustomStringConvertible, LocalizedError {
    case BadArgs        =  1
    case BadCredentials =  2
    case BadMethod      =  3
    case BadReply       =  4
    case Duplicate      =  5
    case Failed         =  6
    case NotAuthorized  =  7
    case NotFound       =  8
    case NotImplemented =  9
    case NotSignedIn    = 10
    case NotSupported   = 11
    case ProtocolError  = 12
    case ReadOnly       = 13
    case Rejected       = 14
    case Suspended      = 15
    case Unreachable    = 16
    case WriteOnly      = 17
    
    public var description      : String  { return "MedKit error \( rawValue ) (\( localizedDescription ))"; }
    public var errorDescription : String? { return MedKitErrorDescription[rawValue]; }
}

/**
 MedKit error localized descriptions.
 */
fileprivate let MedKitErrorDescription = [
    "None",
    "Bad arguments",
    "Bad credentials",
    "Bad method",
    "Bad reply",
    "Duplicate",
    "Failed",
    "Not authorized",
    "Not found",
    "Not implemented",
    "Not signed in",
    "Not supported",
    "Protocol error",
    "Read Only",
    "Rejected",
    "Suspended",
    "Device is unreachable",
    "WriteOnly"
];


// End of File
