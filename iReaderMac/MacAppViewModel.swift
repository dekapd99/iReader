//
//  MacAppViewModel.swift
//  iReaderMac
//
//  Created by Deka Primatio on 08/08/22.
//

import Foundation
import SwiftUI
import VisionKit

class MacAppViewModel: ObservableObject {
    
    @Published var selectedImage: NSImage?
    
    // Cek MacOS Hardware support Live Text Interaction dengan ImageAnalyzer
    var isLiveTextSupported: Bool {
        ImageAnalyzer.isSupported
    }
    
    // Fungsi Import Image
    func importImage() {
        NSOpenPanel.openImage { result in
            if case let .success(image) = result {
                Task { @MainActor in
                    self.selectedImage = image
                }
            }
        }
    }
    
    // Fungsi Drag & Drop Handler
    func handleOnDrop(providers: [NSItemProvider]) -> Bool {
        // Load Image by URL Data from Vision Kit
        if let item = providers.first {
            item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                guard let data = urlData as? Data,
                      let url = URL(dataRepresentation: data, relativeTo: nil),
                      let image = NSImage(contentsOf: url) else { return }
                
                // Show Result of Selected Image
                Task { @MainActor in
                    self.selectedImage = image
                }
            }
            return true
        }
        return false
    }
}

// Extension NSOpenPanel untuk menampilkan File Panel User agar bisa Select Image ketika di klik
extension NSOpenPanel {
    
    // Fungsi User Panel Open Select an Image
    static func openImage(completion: @escaping (_ result: Result<NSImage, Error>) -> ()) {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false // Multiple Image Upload
        panel.canChooseFiles = true // Can Choose Files Only
        panel.canChooseDirectories = false // Cannot Choose a Directory to Upload
        panel.allowedContentTypes = [.image] // Only Able to Upload Image
        
        // Processing Image Upload
        panel.begin { (result) in
            if result == .OK,
               let url = panel.urls.first,
               let image = NSImage(contentsOf: url) {
                completion(.success(image))
            } else {
                completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to Get the Image File"])))
            }
        }
    }
}
