//
//  LoginPage.swift
//  AssetMgmt
//
//  Created by Athenaost on 11/12/23.
//

import SwiftUI

struct LoginPage: View {
    let initialURL = getGetAPIKeyURL()
    @State private var currentURL: URL?
    @State private var gotoLogjcin: Bool = false
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationView {
            if isLoggedIn {
                DirectoryBrowser()
            } else {
                ZStack {
                    Image("duke chapel")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .mask(
                            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), .white]), startPoint: .top, endPoint: .center)
                        )
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Image("mediabeacon")
                            .resizable()
                            .frame(width: 300, height: 65)
                            .aspectRatio(contentMode: .fit)
                            .offset(y: -230)
                        NavigationLink(destination: WebView(url: initialURL, currentURL: $currentURL, isLoggedIn: $isLoggedIn)) {
                            Text("Login")
                                .foregroundColor(.white)
                                .frame(maxWidth: 180, minHeight: 50)
                                .background(Color(red: 28.0/255, green: 33.0/255, blue: 101.0/255))
                                .cornerRadius(40)
                                .font(.system(size: 25))
                        }
                        .offset(y: 210)
                    }
                }
            }
        }
        .onAppear() {
            currentURL = initialURL
            isLoggedIn = loggedIn()
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
