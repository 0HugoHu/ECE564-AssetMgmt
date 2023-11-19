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
    @ObservedObject var viewModel = SearchViewModel()
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 100), spacing: 20)
    ]
    
    var body: some View {
        VStack {
            
            SearchBarView(searchText: $viewModel.searchText,
                          //                          selectedCriteriaConjunction: $viewModel.selectedCriteriaConjunction,
                          //                          selectedField: $viewModel.selectedField,
                          //                          selectedCondition: $viewModel.selectedCondition,
                          //                          showAdvancedSearch: $viewModel.showAdvancedSearch,
                          isSearching: $viewModel.isSearching,
                          searchResults: $viewModel.searchResults,
                          onCommit: {viewModel.search()
                viewModel.updateSearchStatus()
            }
                          //                          onAdvancedSearch: {
                          //                              viewModel.performAdvancedSearch()
                          //                              viewModel.updateSearchStatus()
                          //                          }
            )
            .onChange(of: viewModel.searchText) { _ in
                viewModel.updateSearchStatus()
            }
            
            Spacer()
            
            if viewModel.isSearching {
                SearchResultsView(searchText: $viewModel.searchText,
                                  searchResults: $viewModel.searchResults,
                                  isLoading: $viewModel.isLoading,
                                  columns: [GridItem(.adaptive(minimum: 100), spacing: 20)])
            }
            
        }
        .navigationBarTitle("Search")
    }
}

#Preview {
    SearchView()
}
