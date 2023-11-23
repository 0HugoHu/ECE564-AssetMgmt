//
//  Settings.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/16/23.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedACL: Int = 0
    @State private var selectedTheme: Int = 0
    @State private var selectedAppearanceMode: Int = 0
    @State private var showingSuccessPopup = false
    @StateObject var themeManager = Themes.instance
    @StateObject var appearanceManager = Appearances.instance
    
    @State private var ACLGroups: [ACLGroupsResponse] = []
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let smallerDimension = min(screenWidth, screenHeight)
            let circleSize = 0.25 * smallerDimension
            let centerX = screenWidth / 2
            let centerY = screenHeight / 2
            
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
                                ThemeSelectionView(themeIndex: $0, selectedTheme: selectedTheme)
                                    .id($0 * 100 + selectedTheme)
                            }
                        }
                    }
                }
                
                Section(header: Text("Appearance")) {
                    LazyHStack(spacing: 16) {
                        ForEach(0..<appearanceManager.appearanceArray.count, id: \.self) {
                            AppearanceSelectionView(modeIndex: $0, selectedMode: selectedAppearanceMode)
                                .id($0 * 100 + selectedAppearanceMode)
                        }
                        Spacer()
                    }
                    .frame(height: 80)
                }
                
                Section(header: Text("Actions")) {
                    //                Button("Open Download Folders") {
                    //                    logger.info("\(cacheURL)")
                    //                    if UIApplication.shared.canOpenURL(cacheURL) {
                    //                        UIApplication.shared.open(cacheURL, options: [:], completionHandler: nil)
                    //                    } else {
                    //                        logger.error("Failed to open folder")
                    //                    }
                    //                }
                    
                    Button("Revome All Cache") {
                        UserDefaults.standard.removeObject(forKey: "userInfo")
                        deleteAllFilesInCacheFolder()
                        self.showingSuccessPopup.toggle()
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
                NotificationCenter.default.addObserver(forName: Notification.Name("ReloadThemeSelection"), object: nil, queue: .main) { notification in
                    if let themeIndex = notification.object as? Int {
                        selectedTheme = themeIndex
                        themeManager.reload()
                    }
                }
                NotificationCenter.default.addObserver(forName: Notification.Name("ReloadAppearanceSelection"), object: nil, queue: .main) { notification in
                    if let modeIndex = notification.object as? Int {
                        selectedAppearanceMode = modeIndex
                        appearanceManager.reload()
                    }
                }
            }
            .onChange(of: selectedACL, perform: { newValue in
                UserDefaults.standard.setValue(newValue, forKey: "selectedACL")
                NotificationCenter.default.post(name: Notification.Name("ReloadAccountInfo"), object: nil)
            })
            .onChange(of: selectedTheme, perform: { newValue in
                NotificationCenter.default.post(name: Notification.Name("ReloadAccountInfo"), object: nil)
            })
            .onChange(of: selectedAppearanceMode, perform: { newValue in
                NotificationCenter.default.post(name: Notification.Name("ReloadAccountInfo"), object: nil)
            })
            .popup(isPresented: $showingSuccessPopup) {
                VStack {
                    VStack {}
                        .frame(height: max(screenWidth, screenHeight) * 0.60 / 2)
                    
                    VStack (alignment: .center) {
                        ShineButtonWrapper (x: Int(centerX), y: Int(centerY), r: Int(circleSize), type: .success) {
                            
                        }
                        .offset(x: min(screenWidth, screenHeight) * 0.6 / 2 - circleSize / 2, y: 0)
                        .padding(.top, 48)
                        
                        Spacer()
                        
                        Text("Success")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.bottom, 48)
                    }
                    // TODO: for dark mode
                    .background(Color.white)
                    .frame(width: min(screenWidth, screenHeight) * 0.6, height: max(screenWidth, screenHeight) * 0.35)
                    .cornerRadius(10)
                }
            } customize: {
                $0
                    .isOpaque(true)
                    .type(.floater())
                    .position(.top)
                    .animation(.spring())
                    .closeOnTapOutside(true)
                    .backgroundColor(.black.opacity(0.5))
            }
        }
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
