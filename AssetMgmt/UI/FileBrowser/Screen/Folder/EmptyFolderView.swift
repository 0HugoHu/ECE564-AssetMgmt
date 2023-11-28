//
//  EmptyFolderView.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/20/23.
//

import SwiftUI

struct EmptyFolderView: View {
    @StateObject var themeManager = Themes.instance
    
    var body: some View {
        VStack {
            Image(uiImage: themeManager.getEmptyFolderIcon())
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 150)
                .cornerRadius(5)
                .opacity(0.8)
            
            Text("Folder is empty")
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

#Preview {
    EmptyFolderView()
}
