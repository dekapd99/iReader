//
//  ContentView.swift
//  iReader
//
//  Created by Deka Primatio on 01/07/22.
//

import SwiftUI
import PhotosUI
import VisionKit

// Berisikan Tampilan Beranda Aplikasi
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
            Text("Mohon Memberikan Izin Akses Kamera di Settings")
        case .notDetermined:
            Text("Meminta Izin Akses Kamera")
        }
    } // Batas Body View
    
    // Main View
    private var mainView: some View {
        liveImageFeed
        .background { Color.gray.opacity(0.3) }
        .ignoresSafeArea()
        .id(vm.dataScannerViewId) // Explicit ID Validator untuk Scan Mode: Text
        .sheet(isPresented: .constant(true)) {
            bottomContainerView
                .background(.ultraThinMaterial) // Translucent Background
                .presentationDetents([.medium, .fraction(0.25)])
                .presentationDragIndication(.visible)
                .interactiveDismissDisabled()
                .disabled(vm.capturedPhoto != nil) // Disable User Interaction when Captured Photo Exists
                .onAppear { // Agar Background Translucent Apply ke Apps
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let controller = windowScene.windows.first?.rootViewController?.presentedViewController else {
                        return
                    }
                    controller.view.backgroundColor = .clear
                }
                .sheet(item: $vm.capturedPhoto) { photo in
                    ZStack(alignment: .topTrailing) {
                        LiveTextView(image: photo.image)
                        
                        // Button Dismiss Second Sheet
                        Button {
                            vm.capturedPhoto = nil
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                        }
                        .foregroundColor(.white)
                        .padding([.trailing, .top])
                    } // ZStack LiveTextView
                    .edgesIgnoringSafeArea(.bottom)
                } // Second Sheet
        } // First Sheet
        
        .onChange(of: vm.scanType) { _ in vm.recognizedItems = [] } // Reset List
        .onChange(of: vm.textContentType) { _ in vm.recognizesMultipleItems = [] } // Reset List
        .onChange(of: vm.recognizesMultipleItems) { _ in vm.recognizedItems = [] } // Reset List
        // Medium for selectedPhotoPickerItem changed value
        .onChange(of: vm.selectedPhotoPickerItem) { newValue in
            guard let newValue = else { return }
            // Async Task Modifier for selectedPhotoPickerItem newValue
            Task { @MainActor in
                // New Transferable Protocol that Apple Introduce in iOS 16
                guard let data = try? await newValue.loadTransferable(type: Data.self),
                      let image = UIImageView(data: data) // Passing the downloaded Transferable data
                else { return }
                // Trigger Second Sheet Presentation Containing the LiveTextView
                self.vm.capturedPhoto = .init(image: image)
            }
        }
    } // Batas Main View
    
    // While presenting this captured photo in a second sheet we want to stop the Live Scanner View because it will eat the processing power & battery life, when this live test interaction is being presented with a static image i want to stop the live test scanning
    @ViewBuilder // ViewBuilder Annotation
    private var liveImageFeed: some View {
        if let capturedPhoto = vm.capturedPhoto {
            // Show Captured Photo in Static Image
            Image(uiImage: capturedPhoto.image)
                .resizable()
                .scaledToFit()
        } else {
            DataScannerView(
                shouldCapturePhoto: $vm.shouldCapturePhoto,
                capturedPhoto: $vm.capturedPhoto,
                recognizedItems: $vm.recognizedItems,
                recognizedDataType: vm.recognizedDataType,
                recognizesMultipleItems: vm.recognizesMultipleItems)
        }
    }
    
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
                Picker("Text Type", selection: $vm.textContentType) {
                    ForEach(textContentTypes, id: \.self.1.textContentType) { option in
                        Text(option.title).tag(option.textContentType)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            HStack {
                Text(vm.headerText)
                Spacer()
                
                // Photos Picker: limit to be able to get the Image Only
                PhotosPicker(selection: $vm.selectedPhotoPickerItem, matching: .images) {
                    // View that will be Shown
                    Image(systemName: "photo.circle")
                        .imageScale(.large)
                        .font(.system(size: 32))
                }
                
                // Button Toggle Captured Photo Boolean
                Button {
                    vm.shouldCapturePhoto = true
                } label: {
                    Image(systemName: "camera.circle")
                        .imageScale(.large)
                        .font(.system(size: 32))
                }

            }
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
