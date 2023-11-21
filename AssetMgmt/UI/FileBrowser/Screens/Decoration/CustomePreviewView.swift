//
//  CustomeMenuView.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/20/23.
//

import SwiftUI

struct CustomePreviewView: View {
    @StateObject var themeManager = Themes.instance
    
    var body: some View {
        if let uiDecoration = themeManager.getPreviewIcon() {
            VStack (alignment: .leading) {
                Image(uiImage: uiDecoration)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 180, maxHeight: 50)
                    .opacity(0.8)
            }
            .frame(maxHeight: 60)
        }
        
    }
}

#Preview {
    CustomePreviewView()
}
