//
//  SearchBarView.swift
//  AssetMgmt
//
//  Created by Minghui ZHU on 11/15/23.
//

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
    case overall = "Overall"
    case currentFolder = "Current Folder"
    
    var id: String { self.rawValue }
}

/*
 The Basic Layout of the Search Bar is inspired by:
 https://github.com/UPetersen/SwiftUI-SearchBar
 */
struct SearchBarView: View {
    @Binding var searchText: String
    @State private var showCancelButton: Bool = false
    @Binding var isSearching: Bool
    @Binding var searchResults: [AssetInfoResponse]
    @Binding var selectedSearchDirectoryOption: SearchDirectoryOptions
    
    @Binding var selectedCriteriaConjunction: String
    @Binding var selectedField: String
    @Binding var selectedCondition: String
    @Binding var showAdvancedSearch: Bool
    
    let criteriaConjunction = ["AND", "OR", "NOT"]
    let fieldOptions: [String]
    
    var conditionOptions: [String] {
        guard let fieldType = sampleSearchFiltersDict[selectedField]?.fieldType else { return SearchFilter.FieldTypes.Other.getAllCases() }
        return fieldType.getAllCases()
    }
    
    var onAdvancedSearch: () -> Void
    var onCommit: () -> Void
    
    init(
        searchText: Binding<String>,
        selectedCriteriaConjunction: Binding<String>,
        selectedField: Binding<String>,
        selectedCondition: Binding<String>,
        showAdvancedSearch: Binding<Bool>,
        isSearching: Binding<Bool>,
        searchResults: Binding<[AssetInfoResponse]>,
        selectedSearchDirectoryOption: Binding<SearchDirectoryOptions>,
        onCommit: @escaping () -> Void,
        
        onAdvancedSearch: @escaping () -> Void
    ) {
        self._searchText = searchText
        self._isSearching = isSearching
        self._selectedCriteriaConjunction = selectedCriteriaConjunction
        self._selectedField = selectedField
        self._selectedCondition = selectedCondition
        self._showAdvancedSearch = showAdvancedSearch
        self._searchResults = searchResults
        self._selectedSearchDirectoryOption = selectedSearchDirectoryOption
        self.onCommit = onCommit
        self.onAdvancedSearch = onAdvancedSearch
        self.fieldOptions = Array(sampleSearchFiltersDict.keys)
    }
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.primary)
                
                // Search text field
                ZStack (alignment: .leading) {
                    if searchText.isEmpty {
                        Text("Search")
                            .foregroundColor(.secondary)
                    }
                    TextField("", text: $searchText, onEditingChanged: { isEditing in
                        self.showCancelButton = true
                    }, onCommit: onCommit).foregroundColor(.primary)
                }
                
                if showCancelButton  {
                    
                    // Cancel button
                    Button(action: {
                        UIApplication.shared.endEditing(true)
                        self.searchText = ""
                        self.showCancelButton = false
                        self.isSearching = false
                        self.searchResults = []
                        
                    }) {
                        Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                            .foregroundColor(.primary)
                    }
                }
                
                // AdvancedSearch button
                Button(action: {
                    self.showAdvancedSearch.toggle()
                }) {
                    Image(systemName: "square.stack.3d.up.fill")
                        .foregroundColor(.primary)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.tertiarySystemFill))
            .cornerRadius(10.0)
        }
        .padding(.horizontal)
        .background(Color(UIColor.systemBackground))
        
        if isSearching {
            VStack(spacing: 0) {
                Picker("Select an option", selection: $selectedSearchDirectoryOption) {
                    ForEach(SearchDirectoryOptions.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
            }
            .padding(.top, 5)
        }
        
        if showAdvancedSearch {
            VStack(spacing: 0) {
                // Criteria Conjunction Picker
                HStack {
                    Text("Criteria Conjunction")
                        .font(.callout)
                    Spacer()
                    Picker("Criteria Conjunction", selection: $selectedCriteriaConjunction) {
                        ForEach(criteriaConjunction, id: \.self) { Text($0) }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 0))
                
                Divider()
                
                // Field Picker
                HStack {
                    Text("Select Field")
                        .font(.callout)
                    Spacer()
                    Picker("Select Field", selection: $selectedField) {
                        ForEach(fieldOptions, id: \.self) { Text($0) }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 0))
                
                Divider()
                
                // Condition Picker
                HStack {
                    Text("Select Condition")
                        .font(.callout)
                    Spacer()
                    Picker("Select Condition", selection: $selectedCondition) {
                        ForEach(conditionOptions, id: \.self) { Text($0) }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 0))
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.tertiarySystemFill))
            )
            .padding(.top, 5)
            .padding(.horizontal)
        }
    }
}
