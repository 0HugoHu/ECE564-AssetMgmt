//
//  Settings.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/16/23.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedACL = 0
    @State private var selectedTheme = 0
    @State private var selectedAppearanceMode = 0
    @StateObject var themeManager = Themes.instance
    @StateObject var appearanceManager = Appearances.instance
    
    let acls = ["ACL 1", "ACL 2", "ACL 3"]
    
    var body: some View {
        List {
            Section(header: Text("Access Control List")) {
                Picker("Select ACL", selection: $selectedACL) {
                    ForEach(0..<acls.count, id: \.self) {
                        Text(acls[$0])
                    }
                }
            }
            
            Section(header: Text("Theme")) {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 16) {
                        ForEach(0..<themeManager.themeArray.count, id: \.self) {
                            ThemeSelectionView(themeIndex: $0, selectedTheme: $selectedTheme)
                        }
                    }
                }
            }
            
            Section(header: Text("Appearance")) {
                LazyHStack(spacing: 16) {
                    ForEach(0..<appearanceManager.appearanceArray.count, id: \.self) {
                        AppearanceSelectionView(modeIndex: $0, selectedMode: $selectedAppearanceMode)
                    }
                    Spacer()
                }
                .frame(height: 80)
            }
            
            Section(header: Text("Actions")) {
                Button("Open Download Folders") {
                    // Handle opening download folders
                }
                
                Button("Log Out") {
                    // Handle log out
                }
                .foregroundColor(.red)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Settings")
        .onAppear {
            selectedTheme = themeManager.selectedThemeIndex
            selectedAppearanceMode = appearanceManager.selectedAppearanceIndex
            logger.info("Selected theme: \(selectedTheme)")
            logger.info("Selected appearance: \(selectedAppearanceMode)")
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}


#Preview {
    SettingsView()
}
