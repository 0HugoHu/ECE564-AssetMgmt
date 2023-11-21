//
//  Settings.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/16/23.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedACL: Int = 0
    @State private var selectedTheme = 0
    @State private var selectedAppearanceMode = 0
    @StateObject var themeManager = Themes.instance
    @StateObject var appearanceManager = Appearances.instance
    
    @State private var ACLGroups: [ACLGroupsResponse] = []
    
    var body: some View {
        List {
            Section(header: Text("Access Control List")) {
                Picker("Select ACL", selection: $selectedACL) {
                    ForEach(ACLGroups) { group in
                        Text(group.name)
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
            getACLGroups()
            logger.info("Selected theme: \(selectedTheme)")
            logger.info("Selected appearance: \(selectedAppearanceMode)")
        }
        .onChange(of: selectedACL, perform: { newValue in
            UserDefaults.standard.setValue(newValue, forKey: "selectedACL")
        })
    }
    
    private func getACLGroups() {
        if let jsonData = UserDefaults.standard.data(forKey: "ACLGroups") {
            if let groups = try? JSONDecoder().decode([ACLGroupsResponse].self, from: jsonData) {
                ACLGroups = groups
                selectedACL = UserDefaults.standard.integer(forKey: "selectedACL")
            }
        } else {
            logger.error("Cannot read ACLGroups")
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
