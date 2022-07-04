//
//  ContentView.swift
//  iReader
//
//  Created by Deka Primatio on 01/07/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var vm: AppViewModel // Property Wrapper
    
    var body: some View {
        // Scanner Access Status Switch - Case
        switch vm.dataScannerAccessStatus {
        case .scannerAvailable:
            mainView
        case .cameraNotAvailable:
            Text("Device Anda Tidak Memiliki Camera")
        case .scannerNotAvailable:
            Text("Device Anda Tidak Support Scanning Barcode")
        case .cameraAccessNotGranted:
            Text("Please Provide Access to the Camera in Settings")
        case .notDetermined:
            Text("Requesting Camera Access")
        }
    }
    
    private var mainView: some View {
        DataScannerView(recognizedItems: $vm.recognizedItems,
                        recognizedDataType: vm.recognizedDataType,
                        recognizesMultipleItems: vm.recognizesMultipleItems)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
