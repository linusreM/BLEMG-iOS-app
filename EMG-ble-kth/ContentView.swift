//
//  ContentView.swift
//  EMG-ble-kth
//
//  Created by Linus Remahl on 2021-10-29.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var graph: emgGraph
    @ObservedObject var BLE: BLEManager
    var body: some View {
        VStack {
            //This part is the graph. It's really just a plain path, but graphs with higher abstraction usually aren't great for realtime updates.
            //Currently set to display last 1000 values
            Path{ path in
                let height = UIScreen.main.bounds.height / 3
                let width = UIScreen.main.bounds.width
                let firstSample = { () -> Int in
                    if graph.values.count > 1000 {
                            return graph.values.count - 1000
                    }
                    else {
                            return 0
                    }
                }
                let cutGraph = graph.values[firstSample()..<graph.values.count]
                path.move(to: CGPoint(x:0.0, y:0.0))
                
                cutGraph.enumerated().forEach { index, item in
                    path.addLine(to: CGPoint(x:width*CGFloat(index)/(CGFloat(cutGraph.count)-1.0), y:height*item))
                }
            }
            .stroke(Color.red, lineWidth: 1.5)
            
            
            
            
            Text("Connect to sensor")
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .center)
            List(BLE.BLEPeripherals) { peripheral in
                HStack {
                    Text(peripheral.name).onTapGesture {
                        print(peripheral)
                        BLE.connectSensor(p:peripheral)
                    }
                    Spacer()
                    Text(String(peripheral.rssi))
                }
            }.frame(height: 300)
            Spacer()

            Text("STATUS")
                .font(.headline)

                        // Status goes here
            if BLE.BLEisOn {
                Text("Bluetooth is switched on")
                    .foregroundColor(.green)
            }
            else {
                Text("Bluetooth is NOT switched on")
                    .foregroundColor(.red)
            }

            Spacer()

            HStack {
                VStack (spacing: 10) {
                    Button(action: {
                        BLE.startScanning()
                    }) {
                        Text("Start Scanning")
                    }
                    Button(action: {
                        BLE.stopScanning()
                    }) {
                        Text("Stop Scanning")
                    }
                }.padding()

                Spacer()

                VStack (spacing: 10) {
                    Button(action: {
                        print("Start Advertising")
                    }) {
                        Text("Start Advertising")
                    }
                    Button(action: {
                        print("Stop Advertising")
                    }) {
                        Text("Stop Advertising")
                    }
                }.padding()
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let data: Array<CGFloat> = [
            0.5, 0.6, 0.3, 0.2, 0.4, 0.6, 0, 0.2, 0.5, 0.3, 0.6,
            0.5, 0.6, 0.3, 0.2, 0.4, 0.6, 0, 0.2, 0.5, 0.3, 0.6,
            0.5, 0.6, 0.3, 0.2, 0.4, 0.6, 0, 0.2, 0.5, 0.3, 0.6,
            0.5, 0.6, 0.3, 0.2, 0.4, 0.6, 0, 0.2, 0.5, 0.3, 0.6,
            0.5, 0.6, 0.3, 0.2, 0.4, 0.6, 0, 0.2, 0.5, 0.3, 0.6,
        ]
        let graph = emgGraph(firstValues:data).enableDummyData()
        let BLE = BLEManager()
        ContentView(graph:graph, BLE:BLE)
.previewInterfaceOrientation(.portrait)
    }
}
