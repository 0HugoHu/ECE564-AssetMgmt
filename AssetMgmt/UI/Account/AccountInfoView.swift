//
//  AccountInfoView.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/21/23.
//

import SwiftUI

struct AccountInfoView: View {
    var screenWidth : CGFloat
    @StateObject var themeManager = Themes.instance
    @State var accountInfoLocal = getAccountInfo()
    @State var uiDecoration : UIImage?
    
    var body: some View {
        ZStack {
            if let uiDecoration {
                Image(uiImage: uiDecoration)
                    .resizable()
                    .scaledToFill()
                    .frame(maxHeight: 100)
                    .opacity(0.25)
            }
            
            VStack (alignment: .leading) {
                HStack {
                    VStack (alignment: .leading) {
                        Text("Username:")
                            .font(.caption)
                        BlurView(text: "\(accountInfoLocal["Username"]!)", textSize: 16, startTime: 0, fastAnimation: false)
                    }
                    
                    VStack (alignment: .leading) {
                        Text("Status:")
                            .font(.caption)
                        BlurView(text: "\(accountInfoLocal["Status"]!)", textSize: 16, startTime: 0, fastAnimation: false)
                    }
                    .padding(.leading, 72)
                    
                }
                .padding(.bottom, 8)
                
                HStack {
                    VStack (alignment: .leading) {
                        Text("Department:")
                            .font(.caption)
                        BlurView(text: "\(accountInfoLocal["Department"]!)", textSize: 16, startTime: 0, fastAnimation: true)
                            .lineLimit(2)
                    }
                }
                
                Text(junkString)
                    .foregroundStyle(Color.clear)
                    .frame(height: 0)
                    .padding(.bottom, 8)
            }
            
            
        }
        .onAppear {
            accountInfoLocal = getAccountInfo()
            uiDecoration = themeManager.getUserInfoIcon()
            NotificationCenter.default.addObserver(forName: Notification.Name("ReloadAccountInfo"), object: nil, queue: .main) { _ in
                accountInfoLocal = getAccountInfo()
                uiDecoration = themeManager.getUserInfoIcon()
            }
            
        }
    }
}

#Preview {
    AccountInfoView(screenWidth: 300)
}
