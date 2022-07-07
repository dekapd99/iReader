//
//  iReaderApp.swift
//  iReader
//
//  Created by Deka Primatio on 01/07/22.
//

import SwiftUI

// Root Project: Konfirgurasi AppViewModel di seluruh Project
@main
struct iReaderApp: App {
    
    
    @StateObject private var vm = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // Setup Environment Variabel agar bisa digunakan di Project ini
                .environmentObject(vm)
                .task { // Request Data Scanner Status di Main Thread
                    await vm.requestDataScannerAccessStatus()
                }
        }
    }
}
