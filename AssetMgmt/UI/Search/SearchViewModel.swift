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
                    self.isLoading = false
                }
                return
            }
            
            // Then, fetch the details for each ID
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
            // Handle the search results
            if let firstResult = assetsInfo?.first {
                logger.info("First result name: \(firstResult.id)")
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.searchResults = assetsInfo ?? []
                }
            } else {
                logger.info("No results found")
            }
        }
    }
}
