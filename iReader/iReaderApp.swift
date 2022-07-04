//
//  iReaderApp.swift
//  iReader
//
//  Created by Deka Primatio on 01/07/22.
//

import SwiftUI

@main
struct iReaderApp: App {
    
    @StateObject private var vm = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
                .task {
                    await vm.requestDataScannerAccessStatus()
                }
        }
    }
}
