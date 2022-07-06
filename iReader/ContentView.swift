//
//  ContentView.swift
//  iReader
//
//  Created by Deka Primatio on 01/07/22.
//

import SwiftUI
import VisionKit

struct ContentView: View {
    
    @EnvironmentObject var vm: AppViewModel // Property Wrapper
    
    // Deklarasi Text Content Type
    private let textContentTypes: [(String, textContentType: DataScannerViewController.TextContentType?)] = [
        ("All", .none),
        ("URL", .URL),
        ("Phone", .telephoneNumber),
        ("Email", .emailAddress),
        ("Address", .fullStreetAddress)
    ]
    
    // Body View
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
    } // Batas Body View
    
    // Main View
    private var mainView: some View {
        DataScannerView(
            recognizedItems: $vm.recognizedItems,
            recognizedDataType: vm.recognizedDataType,
            recognizesMultipleItems: vm.recognizesMultipleItems)
        .background { Color.gray.opacity(0.3) }
        .ignoresSafeArea()
        .id(vm.dataScannerViewId) // Explicit ID Validator untuk Scan Mode: Text
        .sheet(isPresented: .constant(true)) {
            bottomContainerView
                .background(.ultraThinMaterial) // Translucent Background
                .presentationDetents([.medium, .fraction(0.25)])
                .presentationDragIndication(.visible)
                .interactiveDismissDisabled()
                .onAppear { // Agar Background Translucent Apply ke Apps
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let controller = windowScene.windows.first?.rootViewController?.presentedViewController else {
                        return
                    }
                    controller.view.backgroundColor = .clear
                }
        }
        
        .onChange(of: vm.scanType) { _ in vm.recognizedItems = [] } // Reset List
        .onChange(of: vm.textContentType) { _ in vm.recognizesMultipleItems = [] } // Reset List
        .onChange(of: vm.recognizesMultipleItems) { _ in vm.recognizedItems = [] } // Reset List
    } // Batas Main View
    
    // Header View
    private var headerView: some View {
        VStack {
            HStack {
                Picker("Scan Type", selection: $vm.scanType) {
                    Text("Barcode").tag(ScanType.barcode)
                    Text("Text").tag(ScanType.text)
                }
                .pickerStyle(.segmented)
                
                Toggle("Scan Multiple", isOn: $vm.recognizesMultipleItems)
            } // Batas HStack
            .padding(.top)
            
            if vm.scanType == .text {
                Picker("Text Content Type", selection: $vm.textContentType) {
                    ForEach(textContentTypes, id: \.self.1.textContentType) { option in
                        Text(option.title).tag(option.textContentType)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Text(vm.headerText).padding(.top)
        } // Batas VStack
        .padding(.horizontal)
    } // Batas Header View
    
    private var bottomContainerView: some View {
        VStack {
            headerView
            ScrollView { // Translution Letter -> For Any Background Color
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(vm.recognizedItems) { item in
                        switch item { // List Hasil Scan Barcode & Text
                        case .barcode(let barcode):
                            Text(barcode.payloadStringValue ?? "Unknown Barcode")
                            
                        case .text(let text):
                            Text(text.transcript)
                            
                        @unknown default:
                            Text("Unknown")
                        }
                    }
                } // Batas LazyVStack
                .padding()
            } // Batas ScrollView
        } // Batas Vstack
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
