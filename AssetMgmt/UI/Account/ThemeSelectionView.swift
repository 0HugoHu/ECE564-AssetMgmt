//
//  ThemeSelectionView.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/16/23.
//

import Foundation
import SwiftUI

struct ThemeSelectionView: View {
    var themeIndex: Int
    @StateObject var themeManager = Themes.instance
    @State var selectedTheme: Int
    
    var body: some View {
        let imgUrl = themeManager.getDirectoryIcon(themeIndex)
        
        return ZStack {
            Rectangle()
                .fill(Color.clear)
                .border(themeIndex == selectedTheme ? Color.accentColor : Color.clear, width: 2)
                .cornerRadius(5)
                .frame(width: 80, height: 80)
            VStack(alignment: .center) {
                Image(uiImage: imgUrl)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 65)
                    .cornerRadius(5)
                
                Text(themeManager.themeArray[themeIndex])
                    .font(.caption)
                    .padding(.top, 2)
            }
        }
        .onTapGesture {
            switch (themeIndex) {
            case 0:
                themeManager.setTheme(theme: .default)
            case 1:
                themeManager.setTheme(theme: .christmas)
            case 2:
                themeManager.setTheme(theme: .newyear)
            case 3:
                themeManager.setTheme(theme: .duke)
            default:
                themeManager.setTheme(theme: .default)
            }
            NotificationCenter.default.post(name: Notification.Name("ReloadThemeSelection"), object: themeIndex)
        }
        .frame(height: 85)
    }
}
