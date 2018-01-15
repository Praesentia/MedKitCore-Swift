/*
 -----------------------------------------------------------------------------
 This source file is part of MedKitCore.
 
 Copyright 2017-2018 Jon Griffeth
 
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


extension sockaddr_storage {
    
    var length: socklen_t { return getLength() }
    
    private func getLength() -> socklen_t
    {
        switch Int32(ss_family) {
        case AF_INET :
            return socklen_t(MemoryLayout<sockaddr_in>.size)
            
        case AF_INET6 :
            return socklen_t(MemoryLayout<sockaddr_in6>.size)
            
        default :
            return socklen_t(MemoryLayout<sockaddr_storage>.size)
        }
    }
    
}


// End of File

