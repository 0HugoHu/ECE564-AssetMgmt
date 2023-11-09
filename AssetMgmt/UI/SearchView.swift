//
//  SearchView.swift
//  AssetMgmt
//
//  Created by Minghui ZHU on 11/2/23.
//
import FilePreviews
import Foundation
import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var searchResults: [AssetInfoResponse] = []
    @State private var isLoading = false
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 100), spacing: 20)
    ]
    
    var body: some View {
        
        VStack {
            
            SearchBarView(searchText: $searchText, onCommit: search)
            
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
                        NavigationLink(destination: DocumentDetailsView(assetInfo: item)) {
                            AssetThumbnailView(assetInfo: item)
                        }
                    }
                }
                .padding()
            }
            Spacer() //
        }
        .navigationBarTitle("Search")
        .onAppear {
            // Perform initial search here
            search()
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

#Preview {
    SearchView()
}
