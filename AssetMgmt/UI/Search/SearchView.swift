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
                          selectedCriteriaConjunction: $viewModel.selectedCriteriaConjunction,
                          selectedField: $viewModel.selectedField,
                          selectedCondition: $viewModel.selectedCondition,
                          showAdvancedSearch: $viewModel.showAdvancedSearch,
                          onCommit: viewModel.search,
                          onAdvancedSearch: viewModel.performAdvancedSearch)
            
            SearchResultsView(searchText: $viewModel.searchText,
                              searchResults: $viewModel.searchResults,
                              isLoading: $viewModel.isLoading,
                              columns: [GridItem(.adaptive(minimum: 100), spacing: 20)])
        }
        .navigationBarTitle("Search")
    }
}

#Preview {
    SearchView()
}
