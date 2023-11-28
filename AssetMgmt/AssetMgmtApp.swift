//
//  AssetMgmtApp.swift
//  AssetMgmt
//
//  Created by Hugooooo on 10/22/23.
//

import SwiftUI
import Logging

let logger = Logger(label: "AssetMgmt")

@main
struct AssetMgmtApp: App {
    @StateObject var appearanceManager = Appearances.instance
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    appearanceManager.reloadScene()
                }
        }
    }
}
