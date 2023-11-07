//
//  SearchView.swift
//  AssetMgmt
//
//  Created by Minghui ZHU on 11/2/23.
//

import Foundation
import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var searchResults: [AssetInfoResponse] = []
    @State private var isLoading = false
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                
                SearchBarView(searchText: $searchText, onCommit: search)
                
//                    TextField("Search", text: $searchText)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding()
                    
//                    Spacer()
//                    
//                    Button(action: {
//                        search()
//                    }) {
//                        Image(systemName: "magnifyingglass")
//                            .padding()
//                    }
//                    .padding(.trailing)
                
                
                HStack {
                    
                    Spacer()
                    
                    Text("\(searchResults.count) matched found")
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
                            AssetThumbnailView(assetInfo: item)
                        }
                    }
                    .padding()
                }
                Spacer() //
            }
            .navigationBarTitle("Search")
        }
    }
    
    func search() {
        isLoading = true
        // First, perform a simple search to get the IDs
        simpleSearch(search: searchText) { simpleIDResponses in
            guard let ids: [String] = simpleIDResponses?.map({ "\($0.id)" }) else {
                // Handle the error or empty state here
                DispatchQueue.main.async {
                    isLoading = false
                }
                return
            }

            // Then, fetch the details for each ID
            getAssetDetails(ids: ids) { assetDetails in
                DispatchQueue.main.async {
                    isLoading = false
                    searchResults = assetDetails ?? []
                }
            }
        }
    }

}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
