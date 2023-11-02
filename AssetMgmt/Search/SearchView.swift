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
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(searchResults, id: \.id) { item in
                                // TODO: Blocked by the File Viewer
                                // NavigationLink(destination: PreviewView(itemId: item.id)) {
                                VStack {
                                    getFileIcon(type: "placeholder")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                    Text("\(item.id)")
                                        .font(.subheadline)
                                }
//                            }
                                .padding(5)
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

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

//struct PreviewView: View {
//    var itemId: Int
//    
//    var body: some View {
//        Text("Preview for item ID: \(itemId)")
//            .padding()
//    }
//}

