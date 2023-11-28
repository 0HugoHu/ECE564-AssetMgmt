//
//  LoginPage.swift
//  AssetMgmt
//
//  Created by Janus on 11/12/23.
//

import SwiftUI

struct LoginPage: View {
    let initialURL = getGetAPIKeyURL()
    @State private var currentURL: URL?
    @State private var gotoLogjcin: Bool = false
    @State private var isLoggedIn: Bool = false
    @State private var showLoginPage: Bool = false
    @State private var loggedOutNotification : NSObjectProtocol? = nil
    
    var body: some View {
        VStack {
            if isLoggedIn {
                TabView {
                    NavigationView {
                        DirectoryBrowser()
                    }
                    .tabItem {
                        Image(systemName: "folder")
                        Text("Browse")
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    
                    SettingsView()
                        .tabItem {
                            Image(systemName: "person")
                            Text("Account")
                        }
                }
                .background(Color(UIColor.systemBackground))
            } else {
                if showLoginPage {
                    WebView(url: initialURL, currentURL: $currentURL, isLoggedIn: $isLoggedIn)
                } else {
                    ZStack {
                        Image("duke chapel")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .mask(
                                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), .white]), startPoint: .top, endPoint: .center)
                            )
                            .edgesIgnoringSafeArea(.all)
                            .background(Color.white)
                        
                        VStack {
                            Image("mediabeacon")
                                .resizable()
                                .frame(width: 300, height: 65)
                                .aspectRatio(contentMode: .fit)
                                .offset(y: -420)
                            Text("Login")
                                .foregroundColor(.white)
                                .frame(maxWidth: 180, minHeight: 50)
                                .background(Color(red: 28.0/255, green: 33.0/255, blue: 101.0/255))
                                .cornerRadius(40)
                                .font(.system(size: 25))
                                .onTapGesture(perform: {
                                    showLoginPage = true
                                })
                        }
                        .offset(y: 210)
                    }
                }
            }
        }
        .onAppear() {
            currentURL = initialURL
            isLoggedIn = loggedIn()
            self.loggedOutNotification = NotificationCenter.default.addObserver(forName: Notification.Name("LoggedOut"), object: nil, queue: .main) { _ in
                isLoggedIn = loggedIn()
            }
        }
    }
    
    private func loggedIn() -> Bool {
        if UserDefaults.standard.value(forKey: "AuthToken") == nil {
            return false
        }
        if let timestamp = UserDefaults.standard.object(forKey: "timestamp") as? Date {
            let currentTime = Date()
            let expiration: TimeInterval = 60 * 60 * 24
            if currentTime.timeIntervalSince(timestamp) < expiration {
                return true
            }
        }
        return false
    }
}

#Preview {
    LoginPage()
}
