//
//  DataScannerView.swift
//  iReader
//
//  Created by Deka Primatio on 04/07/22.
//

import Foundation
import SwiftUI
import VisionKit

// Berisikan Fungsi Wrapper DataScannerView yang disediakan oleh Apple untuk Scanning Data dengan Camera seperti Live Video untuk Text / Data / Barcode / QR Code / Machine Readable Code
// Semua Hal Tersebut akan di Wrap dalam UIViewControllerRepresentable ke dalam SwiftUI View

/**
 * Berisikan Fungsi Wrapper DataScannerView yang disediakan oleh Apple untuk Scanning Data dengan Camera seperti Live Video untuk Text / Data / Barcode / QR Code / Machine Readable Code
 * Semua Hal Tersebut akan di Wrap dalam UIViewControllerRepresentable ke dalam SwiftUI View
*/

struct DataScannerView: UIViewControllerRepresentable {
    
    @Binding var recognizedItems: [RecognizedItem]
    let recognizedDataType: DataScannerViewController.RecognizedDataType
    let recognizesMultipleItems: Bool
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = DataScannerViewController(
            recognizedDataTypes: [recognizedDataType],
            qualityLevel: .balanced,
            recognizesMultipleItems: recognizesMultipleItems,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
        return vc
    }
    
    // Deklarasi Class Coordinator -> Because we want to make sure we conform to delegate of this func (diatas) data scanner view controller we can receive the callback when the items are being recognize or remove from the frame or updated or maybe you want to handle when the user taps one of recognized item
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.delegate = context.coordinator
        // Invoke to Start Scanning Camera Video
        try? uiViewController.startScanning()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(recognizedItems: $recognizedItems)
    }
    
    // Fungsi Static: Cleaning Data Scanner 
    static func dismantleUIViewController(_ uiViewController: UIViewControllerType, coordinator: Coordinator) {
        uiViewController.stopScanning()
    }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        
        @Binding var recognizedItems: [RecognizedItem]
        
        init(recognizedItems: Binding<[RecognizedItem]>) {
            // Akses Undelying Value
            self._recognizedItems = recognizedItems
        }
        
        // Invoke ketika user Tap ke salah satu Recognized Item
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            print("Did Tap On \(item)")
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            recognizedItems.append(contentsOf: addedItems)
            
            print("Did Add Items \(addedItems)")
        }
        
        // Fungsi Filter Item That is Not Contains Removed Items Array
        func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            // If it is We are going to remove it from this recognize items array
            self.recognizedItems = recognizedItems.filter { item in
                !removedItems.contains(where: {$0.id == item.id})
            }
            print("Did Remove Items \(removedItems)")
        }
        
        // Fungsi Error Handling ketika melakukan Data Scanner
        func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
            print("Became Unavailable with Error \(error.localizedDescription)")
        }
    }
}
