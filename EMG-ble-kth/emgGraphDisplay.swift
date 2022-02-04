//
//  emgGraphDisplay.swift
//  EMG-ble-kth
//
//  Created by Linus Remahl on 2021-10-31.
//

import CoreGraphics
import SwiftUI

class emgGraph : ObservableObject{
    @Published private(set) var values: Array<CGFloat>
    
    init(firstValues: Array<CGFloat>){
        values = firstValues
        
    }
    
    
    //This is where values are added to the graph object. If you would want to do software transformations, possibly you could do it here. 
    func append (value:CGFloat) {
        values.append(value)
    }
    func append (values:Array<CGFloat>) {
        self.values += values
    }
    func append (values:Array<Float>) {
        let valuesCGFloat = values.map{CGFloat($0)}
        self.values += valuesCGFloat
    }
    
    func enableDummyData () -> emgGraph {
        _ = Timer.scheduledTimer(
            withTimeInterval: 0.001,
            repeats: true
        ) { _ in self.append(value:CGFloat.random(in: 0.0...1.0))
            if self.values.count > 5000 { self.values = Array(self.values.prefix(2000))}
        }
        return self
    }
}
