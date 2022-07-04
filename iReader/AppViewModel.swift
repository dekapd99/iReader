//
//  AppViewModel.swift
//  iReader
//
//  Created by Deka Primatio on 04/07/22.
//

import Foundation
import SwiftUI
import VisionKit
import AVKit

// Berisikan Deklarasi Data Enum untuk Case Tipe Scan
enum ScanType {
    case barcode, text
}

// Berisikan Deklarasi Data Enum untuk seluruh Case yang mungkin terjadi
enum DataScannerAccessStatusType {
    case notDetermined // ketika user launch App (Default)
    case cameraAccessNotGranted // ketika user tidak memberikan permission penggunaan camera
    case cameraNotAvailable // ketika camera tidak tersedia di device
    case scannerAvailable // ketika data scanner tersedia dan bisa digunakan
    case scannerNotAvailable // ketika data scanner tidak tersedia -> data scanner hanya bisa di versi iOS 12 bionic tidak bisa untuk A11 dan kebawah
}

// Berisikan Fungsi di Main Thread
@MainActor
final class AppViewModel: ObservableObject {
    
    // Initial Value Access Status = not determined
    @Published var dataScannerAccessStatus: DataScannerAccessStatusType = .notDetermined
    
    // Default Value: Recognized Items Array
    @Published var recognizedItems: [RecognizedItem] = []
    
    // Default Scan Type: Barcode
    @Published var scanType: ScanType = .barcode
    
    //
    @Published var textContentType: DataScannerViewController.TextContentType?
    
    //
    @Published var recognizesMultipleItems = true
    
    // Variable Generate Data Type berdasarkan Published Property
    var recognizedDataType: DataScannerViewController.RecognizedDataType {
        scanType == .barcode ? .barcode() : .text(textContentType: textContentType)
    }
    
    
    // Variable Cek apakah Scanner tersedia dan bisa digunakan atau tidak
    private var isScannerAvailable: Bool {
        DataScannerViewController.isAvailable && DataScannerViewController.isSupported
    }
    
    func requestDataScannerAccessStatus() async {
        // Cek apakah device punya kamera hardware
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            // Ketika gak ada camera-nya -> return case camera is not available
            dataScannerAccessStatus = .cameraNotAvailable
            return
        }
        
        // Tanyakan Permission untuk Akses Camera (Video)
        switch AVCaptureDevice.authorizationStatus(for: .video) {

        // Ketika Authorized -> cek apakah scanner tersedia, jika tersedia ubah enum status case menjadi Scanner Available dan jika tidak tersedia ubah enum status case Scanner Not Available
        case .authorized:
            dataScannerAccessStatus = isScannerAvailable ? .scannerAvailable : .scannerNotAvailable
        
        // Ketika Restricted dan Denied -> Jika akses kamera tidak diizinkan dan ditolak oleh user maka ubah enum status case menjadi Camera Access Not Granted
        case .restricted, .denied:
            dataScannerAccessStatus = .cameraAccessNotGranted
            
        // Ketika Not Determined -> Jika akses belum diberikan oleh user / ketika user pertama kali membuka App maka atur default enum status case
        case .notDetermined:
            // Tanyakan Permission to Access Camera (Video)
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if granted { // Jika diberikan Akses oleh User
                dataScannerAccessStatus = isScannerAvailable ? .scannerAvailable : .scannerNotAvailable
            } else { // Jika tidak diberikan Akses oleh User
                dataScannerAccessStatus = .cameraAccessNotGranted
            }
        
        // Default Case
        default: break
            
        }
    }
}
