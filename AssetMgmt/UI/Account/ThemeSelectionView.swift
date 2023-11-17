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
    @Binding var selectedTheme: Int
    @StateObject var themeManager = Themes.instance
    
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
                    .frame(maxWidth: 60)
                    .cornerRadius(5)
                
                Text(themeManager.themeArray[themeIndex] + "  " + (themeIndex == 0 ? " " : ""))
                    .font(.caption)
                    .padding(.top, 2)
            }
        }
        .onTapGesture {
            self.selectedTheme = themeIndex
            switch (selectedTheme) {
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
        }
        .frame(height: 85)
    }
}
