//
//  SearchViewModel.swift
//  AssetMgmt
//
//  Created by Minghui ZHU on 11/15/23.
//

import Foundation
import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [AssetInfoResponse] = []
    @Published var isLoading = false
    @Published var showAdvancedSearch = false
    @Published var selectedCriteriaConjunction = "AND"
    @Published var selectedField = "file_name"
    @Published var selectedCondition = "cont"
    @Published var isSearching = false
    @Published var selectedSearchDirectoryOption = SearchDirectoryOptions.overall
    @Published var currentDirectory: String
    
    init(currentDirectory: String) {
        self.currentDirectory = currentDirectory
    }
    
    func updateSearchStatus() {
        if searchText.isEmpty {
            searchResults = []
        }
        
        isSearching = !searchText.isEmpty || !searchResults.isEmpty
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
        
        let directoryToSearch: String
        switch selectedSearchDirectoryOption {
        case .overall:
            directoryToSearch = "/"
        case .currentFolder:
            directoryToSearch = currentDirectory
        }
        
        
        simpleSearch(search: searchText, directory: directoryToSearch
        ) { simpleIDResponses in
            guard let ids: [String] = simpleIDResponses?.map({ "\($0.id)" }) else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }
            
            getAssetDetails(ids: ids) { assetDetails in
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.searchResults = assetDetails ?? []
                }
            }
        }
    }
    
    func performAdvancedSearch() {
        isLoading = true
        let searchTextAdv = SearchFilter.createSearchCriteria(
            conjunction: SearchFilter.Conjunction(rawValue: selectedCriteriaConjunction) ?? .and,
            fieldId: sampleSearchFiltersDict[selectedField]?.fieldId ?? "",
            condition: SearchFilter.OtherField(rawValue: selectedCondition) ?? .equals,
            value: searchText
        )
        
        // Perform the search
        advancedSearch(search: searchTextAdv, directory: "/", verbose: true) { assetsInfo in
            DispatchQueue.main.async {
                // Always stop loading regardless of the result
                self.isLoading = false
                if let assets = assetsInfo, !assets.isEmpty {
                    logger.info("First result name: \(assets.first!.id)")
                    self.searchResults = assets
                } else {
                    logger.info("No results found")
                    self.searchResults = []
                }
            }
        }
    }
}
