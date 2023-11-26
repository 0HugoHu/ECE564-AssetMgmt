//
//  OperationSuccess.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/22/23.
//

import SwiftUI
import PopupView

struct OperationSuccess: View {
    @State var showingPopup = false
    
    var body: some View {
        VStack {}
            .popup(isPresented: $showingPopup) {
                ShineButtonWrapper (x: 0, y: 0, r: 0, type: .success) {
                    
                }
            } customize: {
                $0
                    .type(.floater())
                    .position(.top)
                    .animation(.spring())
                    .closeOnTapOutside(true)
                    .backgroundColor(.black.opacity(0.5))
            }
    }
}

#Preview {
    OperationSuccess()
}
