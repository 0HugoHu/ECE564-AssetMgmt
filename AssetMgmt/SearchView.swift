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
    @State private var searchResults: [SimpleIDResponse] = []
    @State private var isLoading = false
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
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
                
                HStack {
                    
                    Spacer()
                    
                    Text("\(searchResults.count) matched found")
                        .font(.subheadline)
                        .padding(.top)
                        .padding(.trailing)
                    
                }
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(searchResults, id: \.id) { item in
                            VStack {
                                Image(systemName: "doc")
//                                getFileIcon(type: item.kind) // Assuming item.kind is a string like "doc", "jpg", etc.
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                Text("\(item.id)")
                                    .font(.subheadline)
                            }
                            .padding(5)
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

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
