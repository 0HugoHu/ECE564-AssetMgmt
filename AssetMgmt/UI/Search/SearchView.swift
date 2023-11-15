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
    @State private var selectedCriteriaConjunction: String = "AND"
    @State private var selectedField: String = "file_name"
    @State private var selectedCondition: String = "cont"
    @State private var searchResults: [AssetInfoResponse] = []
    @State private var isLoading = false
    @State private var showAdvancedSearch: Bool = false
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 100), spacing: 20)
    ]
    
    var body: some View {
        VStack {
            
            SearchBarView(searchText: $searchText, selectedCriteriaConjunction: $selectedCriteriaConjunction, selectedField: $selectedField, selectedCondition: $selectedCondition, showAdvancedSearch: $showAdvancedSearch,
                onCommit: search, onAdvancedSearch: performAdvancedSearch)
            
            ScrollView {
                
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
        .navigationBarTitle("Search")
//        .onAppear {
//            // Perform initial search here
//            search()
//        }
    }
    
    
    func search() {
        if showAdvancedSearch {
            performAdvancedSearch()
        } else {
            performSimpleSearch()
        }
    }
    
    func performSimpleSearch() {
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
    
    func performAdvancedSearch() {
        // Construct the search criteria
        isLoading = true
        let searchTextAdv = SearchFilter.createSearchCriteria(
            conjunction: SearchFilter.Conjunction(rawValue: selectedCriteriaConjunction) ?? .and,
            fieldId: sampleSearchFiltersDict[selectedField]?.fieldId ?? "",
            condition: SearchFilter.OtherField(rawValue: selectedCondition) ?? .equals,
            value: searchText
        )

        // Perform the search
        advancedSearch(search: searchTextAdv, directory: "/", verbose: true) { assetsInfo in
            // Handle the search results
            if let firstResult = assetsInfo?.first {
                logger.info("First result name: \(firstResult.id)")
                DispatchQueue.main.async {
                    isLoading = false
                    searchResults = assetsInfo ?? []
                }
            } else {
                logger.info("No results found")
            }
        }
    }
}

#Preview {
    SearchView()
}
