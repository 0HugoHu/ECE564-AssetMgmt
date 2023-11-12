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
                    Image("background")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .mask(
                            LinearGradient(gradient: Gradient(colors: [.clear, .white]), startPoint: .top, endPoint: .center)
                        )
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Image("mediabeacon")
                            .resizable()
                            .frame(width: 300, height: 65)
                            .aspectRatio(contentMode: .fit)
                            .offset(y: -190)
                        NavigationLink(destination: WebView(url: initialURL, currentURL: $currentURL, isLoggedIn: $isLoggedIn)) {
                            Text("Login")
                                .foregroundColor(.white)
                                .frame(maxWidth: 180, minHeight: 50)
                                .background(Color(red: 28.0/255, green: 33.0/255, blue: 101.0/255))
                                .cornerRadius(40)
                                .font(.system(size: 25))
                        }
                        .offset(y: 180)
                    }
                }
            }
        }
        .onAppear() {
            currentURL = initialURL
        }
    }
}

#Preview {
    LoginPage()
}
