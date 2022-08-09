//
//  MacLiveTextView.swift
//  iReaderMac
//
//  Created by Deka Primatio on 08/08/22.
//

import Foundation
import SwiftUI
import VisionKit

// Berisikan Fungsi Live Text Capture for Static Image Uploaded
@MainActor // Annotation for Main Thread
struct MacLiveTextView: NSViewRepresentable {
    
    let image: NSImage // NSImage when MacLiveTextView Initialize
    let imageView = MacLiveTextImageView() // imageView Scheme Type for MacOS
    let overlayView = ImageAnalysisOverlayView() // overlayView for MacOS only
    let analyzer = ImageAnalyzer()
    
    // MacOS NSP Method: The overlayView will properly resize automatically when the parent view changes to MacOS Target Scheme
    func makeNSView(context: Context) -> some NSView {
        imageView.image = image
        overlayView.preferredInteractionTypes = .automatic
        overlayView.autoresizingMask = [.width, .height]
        overlayView.frame = imageView.bounds
        overlayView.trackingImageView = imageView
        imageView.addSubview(overlayView)
        
        return imageView
    }
    
    // Update UIView
    func updateNSView(_ nsView: NSViewType, context: Context) {
        guard let image = imageView.image else { return }
        // Async Task Modifier karena ImageAnalyzer menggunakan Async Await dalam Method-nya
        Task { @MainActor in
            do {
                // MacOS can only Detect Text not Barcode / QR Code / URL for Now
                let configuration = ImageAnalyzer.Configuration([.text])
                let analysis = try await analyzer.analyze(image, orientation: .up, configuration: configuration)
                overlayView.analysis = analysis
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

class MacLiveTextImageView: NSImageView {
    
    // Resize Properly when Embedded in Swift Ui View Representable
    override var intrinsicContentSize: NSSize {
        .zero
    }
    
}
