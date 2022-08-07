//
//  LiveTextView.swift
//  iReader
//
//  Created by Deka Primatio on 07/08/22.
//

import Foundation
import SwiftUI
import VisionKit

// Berisikan Fungsi Live Image Capture
@MainActor // Annotation for Main Thread
struct LiveTextView: UIViewRepresentable {
    
    let image: UIImageView // UI Image when LiveTextView Initialize
    let imageView = LiveTextImageView()
    let analyzer = ImageAnalyzer()
    let interaction = ImageAnalysisInteraction()
    
    // Make UI View Representable Protocol
    func makeUIView(context: Context) -> some UIView {
        imageView.image = image
        imageView.addInteraction(interaction) // Enable Live Text Interaction ke Image View
        imageView.contentMode = .scaleAspectFit // Fit Size dengan Mengatur Aspek Ratio Image Captures
        return imageView
    }
    
    // Update UIView
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let image = imageView.image else { return } // Grab the image dari imageView
        // Async Task Modifier karena ImageAnalyzer menggunakan Async Await dalam Method-nya
        Task { @MainActor in // Annotation for Main Thread
            // Konfigurasi ImageAnalyzer dengan Target spesifik yang membaca Text & machineReadableCode (QR, Barcode, dll.)
            let configuration = ImageAnalyzer.Configuration([.text, .machineReadableCode])
            
            // Get Capture Image, Analysis then Print Result to UI (result: .automatic)
            do {
                let analysis = try await analyzer.analyze(image, configuration: configuration)
                interaction.analysis = analysis
                interaction.preferredInteractionTypes = .automatic
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

// Overwrite Content Size that can be Resizable
class LiveTextImageView: UIImageView {
    
    override var intrinsicContentSize: CGSize {
        .zero
    }
    
}
