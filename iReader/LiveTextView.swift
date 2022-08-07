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
    
}

// Overwrite Content Size that can be Resizable
class LiveTextImageView: UIImageView {
    
    override var intrinsicContentSize: CGSize {
        .zero
    }
    
}
