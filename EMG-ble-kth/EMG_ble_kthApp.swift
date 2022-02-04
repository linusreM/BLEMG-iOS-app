//
//  EMG_ble_kthApp.swift
//  EMG-ble-kth
//
//  Created by Linus Remahl on 2021-10-29.
//

import SwiftUI

@main
struct EMG_ble_kthApp: App {
    var body: some Scene {
        WindowGroup {
            let data: Array<CGFloat> = [0.0]
            let graph = emgGraph(firstValues:data)
            let BLE = BLEManager(emg:graph)
            ContentView(graph:graph, BLE:BLE)
        }
    }
}
