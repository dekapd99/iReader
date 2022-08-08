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
    
    var isLiveTextSupported: Bool {
        // Cek MacOS Hardware support Live Text Interaction dengan ImageAnalyzer
        ImageAnalyzer.isSupported
    }
    
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
        if let item = providers.first {
            item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                guard let data = urlData as? Data,
                      let url = URL(dataRepresentation: data, relativeTo: nil),
                      let image = NSImage(contentsOf: url) else { return }
                
                Task { @MainActor in
                    self.selectedImage = image
                }
            }
            return true
        }
        return false
    }
}

// Use App Kit NSOpenPanel to show the file panel for the user can select the image
extension NSOpenPanel {
    
    // Fungsi User Panel Open Selected Image
    static func openImage(completion: @escaping (_ result: Result<NSImage, Error>) -> ()) {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowedContentTypes = [.image]
        panel.begin { (result) in
            if result == .OK,
               let url = panel.urls.first,
               let image = NSImage(contentsOf: url) {
                completion(.success(image))
                
            } else {
                completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to get the image file"])))
            }
        }
        
    }
    
}
