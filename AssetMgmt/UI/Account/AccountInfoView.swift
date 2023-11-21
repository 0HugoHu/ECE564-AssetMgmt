//
//  AccountInfoView.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/21/23.
//

import SwiftUI

struct AccountInfoView: View {
    
    @StateObject var themeManager = Themes.instance
    @State var accountInfoLocal = getAccountInfo()
    
    var body: some View {
        ZStack {
            if let uiDecoration = themeManager.getUserInfoIcon() {
                Image(uiImage: uiDecoration)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 180, maxHeight: 80)
                    .opacity(0.4)
            }
                
            
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)]) {
                HStack {
                    VStack (alignment: .leading) {
                        Text("Username:")
                            .font(.caption)
                        Text("\(accountInfoLocal["Username"]!)")
                            .font(.callout)
                    }
                    .padding(.bottom, 8)
                    Spacer()
                }
                HStack {
                    VStack (alignment: .leading) {
                        Text("Status:")
                            .font(.caption)
                        Text("\(accountInfoLocal["Status"]!)")
                            .font(.callout)
                    }
                    .padding(.bottom, 8)
                    Spacer()
                }
                HStack {
                    VStack (alignment: .leading) {
                        Text("Type:")
                            .font(.caption)
                        Text("\(accountInfoLocal["Type"]!)")
                            .font(.callout)
                    }
                    .padding(.bottom, 8)
                    Spacer()
                }
                HStack {
                    VStack (alignment: .leading) {
                        Text("Department:")
                            .font(.caption)
                        Text("\(accountInfoLocal["Department"]!)")
                            .font(.callout)
                    }
                    .padding(.bottom, 8)
                    Spacer()
                }
            }
        }
        .onAppear {
            accountInfoLocal = getAccountInfo()
//            logger.info(accountInfoLocal["Username"]!)
        }
    }
}

#Preview {
    AccountInfoView()
}
