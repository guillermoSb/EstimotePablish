//
//  ContentView.swift
//  EstimotePablish
//
//  Created by Guillermo Santos Barrios on 5/19/24.
//

import SwiftUI
import EstimoteUWB

struct ContentView: View {
    @ObservedObject
    var uwb = EstimoteUWBManagerExample()
    
    var body: some View {
        
        VStack {
            Text("Distance 1 \(uwb.distance1)")
            Text("Distance 2 \(13)")
            Text("Distance 3 \(13)")
        }
        Text("Estimote UWB")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class EstimoteUWBManagerExample: NSObject, ObservableObject {
    private var uwbManager: EstimoteUWBManager?
    let sensor1Id = ""
    let sensor2Id = ""
    let sensor3Id = "4056668d19dfe5fab47c9e83c82a982b"
    
    @Published var distance1: Float = 0.0
    @Published var distance2: Float = 0.0
    @Published var distance3: Float = 0.0

    override init() {
        super.init()
        setupUWB()
    }

    private func setupUWB() {
        print("Estimote setup")
        uwbManager = EstimoteUWBManager(delegate: self,
                                        options: EstimoteUWBOptions(shouldHandleConnectivity: true,
                                                                    isCameraAssisted: false))
        uwbManager?.startScanning()
    }
}

// REQUIRED PROTOCOL
extension EstimoteUWBManagerExample: EstimoteUWBManagerDelegate {
   
    func didUpdatePosition(for device: EstimoteUWBDevice) {
        let id = device.id
        print("Device ID: ")
        switch id {
        case sensor1Id:
            distance1 = device.distance
            break
        case sensor2Id:
            distance2 = device.distance
            break
        case sensor3Id:
            distance3 = device.distance
        default:
            break
        }
        print(distance3)
        
        
    }
    
    // OPTIONAL
    func didDiscover(device: UWBIdentifiable, with rssi: NSNumber, from manager: EstimoteUWBManager) {
        print("Discovered device: \(device.publicIdentifier) rssi: \(rssi)")
        // if shouldHandleConnectivity is set to true - then you could call manager.connect(to: device)
        // additionally you can globally call discoonect from the scope where you have inititated EstimoteUWBManager -> disconnect(from: device) or disconnect(from: publicId)
    }
    
    // OPTIONAL
    func didConnect(to device: UWBIdentifiable) {
        print("Successfully connected to: \(device.publicIdentifier)")
    }
    
    // OPTIONAL
    func didDisconnect(from device: UWBIdentifiable, error: Error?) {
        print("Disconnected from device: \(device.publicIdentifier)- error: \(String(describing: error))")
    }
    
    // OPTIONAL
    func didFailToConnect(to device: UWBIdentifiable, error: Error?) {
        print("Failed to conenct to: \(device.publicIdentifier) - error: \(String(describing: error))")
    }

    // OPTIONAL PROTOCOL FOR BEACON BLE RANGING
//    func didRange(for beacon: EstimoteBLEDevice) {
//        print("Beacon did range: \(beacon)")
//    }
}


