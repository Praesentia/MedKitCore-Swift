/*
 -----------------------------------------------------------------------------
 This source file is part of MedKit Device Simulator.
 
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


/**
 DataLog delegate.
 */
public protocol DataLogDelegate: class {
    
    func dataLog(_ dataLog: DataLog, didAppend item: DataLogItem)
    func dataLog(_ dataLog: DataLog, didRemove item: DataLogItem, at index: Int)
    
}

/**
 Data log.
 */
public class DataLog: DataTap {
    
    public weak var delegate : DataLogDelegate?
    public var      items    = [DataLogItem]()
    public var      maxItems : Int = 1000
    
    private var sequence : Int = 1
    
    public init()
    {
    }
    
    public func clear()
    {
        items.removeAll()
    }
    
    private func appendItem(_ item: DataLogItem)
    {
        if items.count >= maxItems {
            prune(count: (items.count + 1) - maxItems)
        }
        
        items.append(item)
        delegate?.dataLog(self, didAppend: item)
    }
    
    private func prune(count: Int)
    {
        for _ in 0..<count {
            let item = items[0]
            
            items.removeFirst(1)
            delegate?.dataLog(self, didRemove: item, at: 0)
        }
    }
    
    // MARK: - PortTapDataTap
    
    public func dataTap(_ sender: Any, willSend data: Data, decoderFactory: DataDecoderFactory)
    {
        let item = DataLogItem(sequence: sequence, direction: .send, time: Date.timeIntervalSinceReferenceDate, data: data, decoderFactory: decoderFactory)
        
        sequence += 1
        appendItem(item)
    }
    
    public func dataTap(_ sender: Any, didReceive data: Data, decoderFactory: DataDecoderFactory)
    {
        let item = DataLogItem(sequence: sequence, direction: .receive, time: Date.timeIntervalSinceReferenceDate, data: data, decoderFactory: decoderFactory)
        
        sequence += 1
        appendItem(item)
    }
    
}


// End of File
