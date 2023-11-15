//
//  SearchResultsView.swift
//  AssetMgmt
//
//  Created by Minghui ZHU on 11/15/23.
//

import Foundation
import SwiftUI

struct SearchResultsView: View {
    @Binding var searchText: String
    @Binding var searchResults: [AssetInfoResponse]
    @Binding var isLoading: Bool
    let columns: [GridItem]
    
    var body: some View {
        ScrollView {
            HStack {
                Spacer()
                Text("\(searchResults.count) matches found")
                    .font(.subheadline)
                    .padding(.top)
                    .padding(.trailing)
            }
            .navigationBarTitle(Text("MediaBeacon"))
            .resignKeyboardOnDragGesture()
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(searchResults, id: \.id) { item in
                        NavigationLink(destination: DocumentDetails(document: convertToDocument(from: item), mode: .remote)) {
                            AssetThumbnailViewGrid(assetInfo: item)
                        }
                    }
                }
                .padding()
            }
            Spacer()
        }
    }
}
