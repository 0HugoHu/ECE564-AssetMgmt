//
//  AppearanceSelectionView.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/16/23.
//

import Foundation
import SwiftUI

struct AppearanceSelectionView: View {
    var modeIndex: Int
    @StateObject var appearanceManager = Appearances.instance
    @State var selectedMode: Int
    
    var body: some View {
        let imgUrl = appearanceManager.getModeIcon(modeIndex)
        
        return ZStack {
            Rectangle()
                .fill(Color.clear)
                .border(modeIndex == selectedMode ? Color.accentColor : Color.clear, width: 2)
                .cornerRadius(5)
                .frame(width: 80, height: 80)
            VStack(alignment: .center) {
                Image(uiImage: imgUrl)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 50)
                    .cornerRadius(5)
                
                Text(appearanceManager.appearanceArray[modeIndex])
                    .font(.caption)
                    .padding(.top, 2)
            }
        }
        .onTapGesture {
            switch (modeIndex) {
            case 0:
                appearanceManager.setMode(mode: .light)
            case 1:
                appearanceManager.setMode(mode: .default)
            case 2:
                appearanceManager.setMode(mode: .dark)
            default:
                appearanceManager.setMode(mode: .default)
            }
            NotificationCenter.default.post(name: Notification.Name("ReloadAppearanceSelection"), object: modeIndex)
        }
        .frame(height: 80)
    }
}
