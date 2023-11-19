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
    @ObservedObject var searchViewModel = SearchViewModel(currentDirectory: "/")
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 100), spacing: 20)
    ]
    
    var body: some View {
        VStack {
            
            SearchBarView(
                searchText: $searchViewModel.searchText,
                          selectedCriteriaConjunction: $searchViewModel.selectedCriteriaConjunction,
                          selectedField: $searchViewModel.selectedField,
                          selectedCondition: $searchViewModel.selectedCondition,
                          showAdvancedSearch: $searchViewModel.showAdvancedSearch,
                          isSearching: $searchViewModel.isSearching,
                          searchResults: $searchViewModel.searchResults,
                          selectedSearchDirectoryOption:$searchViewModel.selectedSearchDirectoryOption,
                          onCommit: {searchViewModel.search()
                searchViewModel.updateSearchStatus()
            },
                          onAdvancedSearch: {
                searchViewModel.performAdvancedSearch()
                searchViewModel.updateSearchStatus()
            }
            )
            .onChange(of: searchViewModel.searchText) { _ in
                searchViewModel.updateSearchStatus()
            }
            .onChange(of: searchViewModel.selectedSearchDirectoryOption) { _ in
                searchViewModel.search()
            }
            Spacer()
            
            if searchViewModel.isSearching {
                SearchResultsView(searchText: $searchViewModel.searchText,
                                  searchResults: $searchViewModel.searchResults,
                                  isLoading: $searchViewModel.isLoading,
                                  columns: [GridItem(.adaptive(minimum: 100), spacing: 20)])
            }
            
        }
        .navigationBarTitle("Search")
    }
}

#Preview {
    SearchView()
}
