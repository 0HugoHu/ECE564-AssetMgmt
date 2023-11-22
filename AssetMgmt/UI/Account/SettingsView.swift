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
            Section(header: Text("Account Info")) {
                AccountInfoView()
            }
            
            Section(header: Text("Access Control List")) {
                Picker("Current ACL", selection: $selectedACL) {
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
                
                Button("Revome Cache") {
                    UserDefaults.standard.removeObject(forKey: "userInfo")
                }
                
                Button("Log Out") {
                    UserDefaults.standard.removeObject(forKey: "AuthToken")
                    UserDefaults.standard.removeObject(forKey: "timestamp")
                    NotificationCenter.default.post(name: Notification.Name("LoggedOut"), object: nil)
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
            NotificationCenter.default.post(name: Notification.Name("ReloadAccountInfo"), object: nil)
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
