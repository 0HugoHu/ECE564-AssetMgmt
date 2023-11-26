//
//  Themes.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/16/23.
//

import Foundation
import UIKit

enum Theme: String, CaseIterable {
    case `default` = "Default"
    case christmas = "Christmas"
    case newyear = "New Year"
    case duke = "Duke"
}

class Themes : ObservableObject {
    static let instance = Themes()
    
    private let themeKey = "Theme"
    let themeArray = Theme.allCases.map { $0.rawValue }
    
    
    var currentTheme: Theme {
        didSet {
            saveCurrentTheme()
        }
    }
    @Published var selectedThemeIndex = 0
    
    private init() {
        if let savedThemeRawValue = UserDefaults.standard.string(forKey: themeKey),
           let savedTheme = Theme(rawValue: savedThemeRawValue) {
            self.currentTheme = savedTheme
            
            switch (currentTheme) {
            case .default:
                selectedThemeIndex = 0
            case .christmas:
                selectedThemeIndex = 1
            case .newyear:
                selectedThemeIndex = 2
            case .duke:
                selectedThemeIndex = 3
            }
        } else {
            self.currentTheme = .default
        }
    }
    
    func setTheme(theme: Theme) {
        currentTheme = theme
    }
    
    func getDirectoryIcon() -> UIImage {
        switch (self.currentTheme) {
        case .christmas:
            return UIImage(named: "icon_directory_christmas")!
        case .newyear:
            return UIImage(named: "icon_directory_newyear")!
        case .duke:
            return UIImage(named: "icon_directory_duke")!
        default:
            return UIImage(named: "icon_directory_default")!
        }
    }
    
    
    func getDirectoryIcon(_ index: Int) -> UIImage {
        switch (index) {
        case 0:
            return UIImage(named: "icon_directory_default")!
        case 1:
            return UIImage(named: "icon_directory_christmas")!
        case 2:
            return UIImage(named: "icon_directory_newyear")!
        case 3:
            return UIImage(named: "icon_directory_duke")!
        default:
            return UIImage(named: "icon_directory_default")!
        }
    }
    
    func getEmptyFolderIcon() -> UIImage {
        switch (self.currentTheme) {
        case .christmas:
            return UIImage(named: "empty_christmas")!
        case .newyear:
            return UIImage(named: "empty_newyear")!
        case .duke:
            return UIImage(named: "empty_duke")!
        default:
            return UIImage(named: "empty_default")!
        }
    }
    
    func getPreviewIcon() -> UIImage? {
        switch (self.currentTheme) {
        case .christmas:
            return UIImage(named: "decoration_christmas_1")!
        case .newyear:
            return UIImage(named: "decoration_newyear_1")!
        case .duke:
            return UIImage(named: "decoration_duke_1")!
        default:
            return nil
        }
    }
    
    func getUserInfoIcon() -> UIImage? {
        switch (self.currentTheme) {
        case .christmas:
            return UIImage(named: "decoration_christmas_2")!
        case .newyear:
            return UIImage(named: "decoration_newyear_2")!
        case .duke:
            return UIImage(named: "decoration_duke_2")!
        default:
            return nil
        }
    }
    
    private func saveCurrentTheme() {
        UserDefaults.standard.set(currentTheme.rawValue, forKey: themeKey)
    }
}

