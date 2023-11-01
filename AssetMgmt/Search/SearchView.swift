//
//  SearchView.swift
//  AssetMgmt
//
//  Created by Minghui ZHU on 11/1/23.
//

import Foundation
import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var searchResults: [SimpleIDResponse] = []
    @State private var isLoading = false
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        search()
                    }) {
                        Image(systemName: "magnifyingglass")
                            .padding()
                    }
                    .padding(.trailing)
                }
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(searchResults, id: \.id) { item in
                                // TODO: Blocked by the File Viewer
//                                NavigationLink(destination: PreviewView(itemId: item.id)) {
                                    VStack {
                                        Text("ID: \(item.id)")
                                            .font(.headline)
                                    }
                                    .padding()
                                    .frame(height: 100)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
//                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitle("Search")
        }
    }
    
    func search() {
        isLoading = true
        simpleSearch(search: searchText) { results in
            isLoading = false
            if let results = results {
                searchResults = results
            } else {
                searchResults = []
            }
        }
    }
}



struct PreviewView: View {
    var itemId: Int
    
    var body: some View {
        Text("Preview for item ID: \(itemId)")
            .padding()
    }
}

