//
//  Themes.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/16/23.
//

import Foundation
import UIKit

enum Theme: String, CaseIterable {
    case `default`
    case christmas
    case newyear
    case duke
}

class Themes : ObservableObject {
    static let instance = Themes()
    
    private let themeKey = "SelectedTheme"
    
    var currentTheme: Theme {
        didSet {
            saveCurrentTheme()
        }
    }
    
    private init() {
        self.currentTheme = Theme(rawValue: UserDefaults.standard.string(forKey: themeKey) ?? "duke")!
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
            return UIImage(named: "icon_directory")!
        }
    }
    
    private func saveCurrentTheme() {
        UserDefaults.standard.set(currentTheme, forKey: themeKey)
    }
}

