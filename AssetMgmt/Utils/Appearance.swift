//
//  Appearance.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/16/23.
//

import Foundation
import UIKit

enum Appearance: String, CaseIterable {
    case light = "Light"
    case `default` = "System"
    case dark = "Dark"
}

class Appearances: ObservableObject {
    static let instance = Appearances()
    
    private let modeKey = "AppearanceMode"
    let appearanceArray = Appearance.allCases.map { $0.rawValue }
    
    var currentMode: Appearance {
        didSet {
            saveCurrentMode()
        }
    }
    var selectedAppearanceIndex = 0
    
    private init() {
        if let savedModeRawValue = UserDefaults.standard.string(forKey: modeKey),
           let savedMode = Appearance(rawValue: savedModeRawValue) {
            self.currentMode = savedMode
            
            switch (currentMode) {
            case .light:
                selectedAppearanceIndex = 0
            case .default:
                selectedAppearanceIndex = 1
            case .dark:
                selectedAppearanceIndex = 2
            }
        } else {
            self.currentMode = .default
        }
    }
    
    func reload() {
        if let savedModeRawValue = UserDefaults.standard.string(forKey: modeKey),
           let savedMode = Appearance(rawValue: savedModeRawValue) {
            self.currentMode = savedMode
            
            switch (currentMode) {
            case .light:
                selectedAppearanceIndex = 0
            case .default:
                selectedAppearanceIndex = 1
            case .dark:
                selectedAppearanceIndex = 2
            }
        } else {
            self.currentMode = .default
        }
    }
    
    func setMode(mode: Appearance) {
        currentMode = mode
    }
    
    private func saveCurrentMode() {
        UserDefaults.standard.set(currentMode.rawValue, forKey: modeKey)
        reloadScene()
    }
    
    func reloadScene() {
        // Change application-wide setting
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        switch currentMode {
        case .default:
            window!.overrideUserInterfaceStyle = .unspecified
        case .dark:
            window!.overrideUserInterfaceStyle = .dark
        case .light:
            window!.overrideUserInterfaceStyle = .light
        }
    }
    
    
    func getModeIcon() -> UIImage {
        switch (self.currentMode) {
        case .dark:
            return UIImage(named: "icon_dark_mode")!
        case .light:
            return UIImage(named: "icon_light_mode")!
        default:
            return UIImage(named: "icon_system_mode")!
        }
    }
    
    
    func getModeIcon(_ index: Int) -> UIImage {
        switch (index) {
        case 0:
            return UIImage(named: "icon_light_mode")!
        case 1:
            return UIImage(named: "icon_system_mode")!
        case 2:
            return UIImage(named: "icon_dark_mode")!
        default:
            return UIImage(named: "icon_system_mode")!
        }
    }
}

