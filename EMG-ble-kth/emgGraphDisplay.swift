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
    var recorded_values: Array<CGFloat> = []
    var recording: Bool = false
    var start_time: CFTimeInterval = 0
    
    init(firstValues: Array<CGFloat>){
        values = firstValues
    }
    
    func record(){
        recording = true
        start_time = CACurrentMediaTime()
    }
    
    func stop_recording_and_save() -> String {
        let time_recorded: CFTimeInterval = CACurrentMediaTime() - start_time
        recording = false
        let dataset = "[capture time: " + time_recorded.description + "]\n" +
        recorded_values.description.replacingOccurrences(of: "[", with: "")
            .replacingOccurrences(of: ", ", with: "\n")
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let date = Date()
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "en_US_POSIX")
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH_mm_ss"
        
        
        let filename = paths[0].appendingPathComponent("emg_data_" +
            dateformatter.string(from: date) +
            ".csv")
        debugPrint(filename)

        do {
            try dataset.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            debugPrint("Failed to write file")
        }
        
        recorded_values.removeAll()
        return dataset
    }
    
    //This is where values are added to the graph object. If you would want to do software transformations, possibly you could do it here. 
    func append (value:CGFloat) {
        if recording {
                recorded_values.append(value)
        }
        values.append(value)
    }
    func append (values:Array<CGFloat>) {
        if recording {
            self.recorded_values += values
        }
        self.values += values
    }
    func append (values:Array<Float>) {
        let valuesCGFloat = values.map{CGFloat($0)}
        self.values += valuesCGFloat
        if recording {
            self.recorded_values += valuesCGFloat
        }
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
