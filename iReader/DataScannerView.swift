//
//  DataScannerView.swift
//  iReader
//
//  Created by Deka Primatio on 04/07/22.
//

import Foundation
import SwiftUI
import VisionKit

/**
 * Berisikan Fungsi Wrapper DataScannerView yang disediakan oleh Apple untuk Scanning Data dengan Camera seperti Live Video untuk Text / Data / Barcode / QR Code / Machine Readable Code
 * Semua Hal Tersebut akan di Wrap dalam UIViewControllerRepresentable ke dalam SwiftUI View
*/
struct DataScannerView: UIViewControllerRepresentable {
    
    @Binding var recognizedItems: [RecognizedItem] // Binding data: Item yang dikenali
    let recognizedDataType: DataScannerViewController.RecognizedDataType // Tipe Data yang dikenali
    let recognizesMultipleItems: Bool // Default Item yang dikenali dalam jumlah banyak
    
    // Default makeUIViewController berdasarkan mode yang ada
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
    
    // Fungsi Perubahan UIViewController menggunakan Akses Kamera
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.delegate = context.coordinator
        // Meminta untuk Start Scanning Camera Video
        try? uiViewController.startScanning()
    }
    
    // Fungsi Pembuatan Coordinator ketika Mengenail Items dengan Camera
    func makeCoordinator() -> Coordinator {
        Coordinator(recognizedItems: $recognizedItems)
    }
    
    // Fungsi Static: Cleaning Data Scanner untuk Stop Scan
    static func dismantleUIViewController(_ uiViewController: UIViewControllerType, coordinator: Coordinator) {
        uiViewController.stopScanning()
    }
    
    // Class Coordinator
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        
        @Binding var recognizedItems: [RecognizedItem] // Binding data: Mengenali Item
        
        init(recognizedItems: Binding<[RecognizedItem]>) {
            // Akses Undelying Value ketika Mengenali Item
            self._recognizedItems = recognizedItems
        }
        
        // Fungsi Klik salah satu item yang dikenali dan ditambahkan ke dalam List Hasil Scan
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            print("Klik \(item)")
        }
        
        // Fungsi Scan Item yang dikenali dan ditambahkan ke dalam List Hasil Scan
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            // Jika sukses maka kita akan menampilkan item yang dikenali ke dalam List Hasil Scan
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            recognizedItems.append(contentsOf: addedItems)
            print("Item yang ditambahkan \(addedItems)")
        }
        
        // Fungsi Filter Item berdasarkan Mode yang dipilih
        func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            // Jika True maka kita tidak akan memunculkan hasilnya di List Hasil Scan
            self.recognizedItems = recognizedItems.filter { item in
                !removedItems.contains(where: {$0.id == item.id})
            }
            print("Item yang Terhapus \(removedItems)")
        }
        
        // Fungsi Error Handling ketika melakukan Data Scanner
        func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
            print("Tidak Dapat di Akses Karena Error \(error.localizedDescription)")
        }
    }
}
