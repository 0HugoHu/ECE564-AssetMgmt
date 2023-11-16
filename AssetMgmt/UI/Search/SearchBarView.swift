//
//  SearchBarView.swift
//  AssetMgmt
//
//  Created by Minghui ZHU on 11/6/23.
//
// Sample Search Bar

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing(_ force: Bool) {
        if #available(iOS 15.0, *) {
            // For iOS 15.0 and later
            UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }?.endEditing(force)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.windows
                .filter { $0.isKeyWindow }
                .first?.endEditing(force)
        }
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        modifier(ResignKeyboardOnDragGesture())
    }
}


enum SearchDirectoryOptions: String, CaseIterable, Identifiable {
    case currentFolder = "Current Folder"
    case overall = "Overall"

    var id: String { self.rawValue }
}


struct SearchBarView: View {
    @Binding var searchText: String
    @State private var showCancelButton: Bool = false
    
    @Binding var selectedCriteriaConjunction: String
    @Binding var selectedField: String
    @Binding var selectedCondition: String
    
    @Binding var showAdvancedSearch: Bool
    
    @Binding var isSearching: Bool
    
    @Binding var searchResults: [AssetInfoResponse]
    
    @State private var selectedSearchDirectoryOption: SearchDirectoryOptions = .overall

    
    let criteriaConjunction = ["AND", "OR", "NOT"]
    let fieldOptions: [String]
    
    var conditionOptions: [String] {
        guard let fieldType = sampleSearchFiltersDict[selectedField]?.fieldType else { return SearchFilter.FieldTypes.Other.getAllCases() }
        return fieldType.getAllCases()
    }
    
    var onCommit: () -> Void
    var onAdvancedSearch: () -> Void
    
    init(searchText: Binding<String>,
         selectedCriteriaConjunction: Binding<String>,
         selectedField: Binding<String>,
         selectedCondition: Binding<String>,
         showAdvancedSearch: Binding<Bool>,
         isSearching: Binding<Bool>, // Change this line
         searchResults: Binding<[AssetInfoResponse]>,
         onCommit: @escaping () -> Void,
         onAdvancedSearch: @escaping () -> Void
    ) {
        self._searchText = searchText
        self._selectedCriteriaConjunction = selectedCriteriaConjunction
        self._selectedField = selectedField
        self._selectedCondition = selectedCondition
        
        self._showAdvancedSearch = showAdvancedSearch
        self._searchResults = searchResults
        
        self.onCommit = onCommit
        self.onAdvancedSearch = onAdvancedSearch
        
        self._isSearching = isSearching
        
        self.fieldOptions = Array(sampleSearchFiltersDict.keys)
    }
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                
                // Search text field
                ZStack (alignment: .leading) {
                    if searchText.isEmpty { // Separate text for placeholder to give it the proper color
                        Text("Search")
                    }
                    TextField("", text: $searchText, onEditingChanged: { isEditing in
                        self.showCancelButton = true
                    }, onCommit: onCommit).foregroundColor(.primary)
                }
                
                if showCancelButton  {
                    // Cancel button
                    
                    Button(action: {
                        UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                        self.searchText = ""
                        self.showCancelButton = false
                        self.isSearching = false
                        self.searchResults = []
                        
                    }) {
                        Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                    }
                }
                        
                // AdvancedSearch button
                Button(action: {
                    self.showAdvancedSearch.toggle()
                }) {
                    Image(systemName: "ellipsis.circle")
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary) // For magnifying glass and placeholder test
            .background(Color(.tertiarySystemFill))
            .cornerRadius(10.0)
        }
        .padding(.horizontal)
        
        VStack(spacing: 0) {
            Picker("Select an option", selection: $selectedSearchDirectoryOption) {
                ForEach(SearchDirectoryOptions.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented) // Use .segmented or other styles as per your UI needs
//            .frame(height: 150)
            .padding(.horizontal)
        }
            
        
        
        
        //        .navigationBarHidden(showCancelButton)
        
        // Advanced search fields
        if showAdvancedSearch {
            
            VStack(spacing: 0) {
                    HStack {
                        Text("Criteria Conjunction")
                        Spacer()
                        Picker("Criteria Conjunction", selection: $selectedCriteriaConjunction) {
                            ForEach(criteriaConjunction, id: \.self) { Text($0) }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: .infinity, alignment: .trailing) // Adjust to your needs
                    }

                    .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 0))
                    .background(Color(.tertiarySystemFill))

                    HStack {
                        Text("Select Field")
                        Spacer()
                        Picker("Select Field", selection: $selectedField) {
                            ForEach(fieldOptions, id: \.self) { Text($0) }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: .infinity, alignment: .trailing) // Adjust to your needs
                    }
                    .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 0))
                    .background(Color(.tertiarySystemFill))

                    HStack {
                        Text("Select Condition")
                        Spacer()
                        Picker("Select Condition", selection: $selectedCondition) {
                            ForEach(conditionOptions, id: \.self) { Text($0) }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: .infinity, alignment: .trailing) // Adjust to your needs
                    }
                    .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 0))
                    .background(Color(.tertiarySystemFill))

            }
            .padding(.horizontal)
            .cornerRadius(10.0)
            
        }
    }
}
