//
//  iReaderMacApp.swift
//  iReaderMac
//
//  Created by Deka Primatio on 08/08/22.
//

import SwiftUI

// Root Project: Konfirgurasi AppViewModel di seluruh Project MacOS
@main
struct iReaderMacApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 512, maxWidth: 512) // Limit the windows by Setting the frame of content view
        }
    }
}
