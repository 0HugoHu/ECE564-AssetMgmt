//
//  SearchBarView.swift
//  AssetMgmt
//
//  Created by Minghui ZHU on 11/6/23.
//
// Sample Search Bar

import Foundation
import SwiftUI

struct SearchBarContentView: View {
    let array = ["Peter", "Paul", "Mary", "Anna-Lena", "George", "John", "Greg", "Thomas", "Robert", "Bernie", "Mike", "Benno", "Hugo", "Miles", "Michael", "Mikel", "Tim", "Tom", "Lottie", "Lorrie", "Barbara"]
    
    private func search() {
        // Your search logic here
        print("Search for \(searchText)")
    }
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                
                // Search view
                SearchBarView(searchText: $searchText, onCommit: search)
                
                List {
                    // Filtered list of names
                    ForEach(array.filter{$0.hasPrefix(searchText) || searchText == ""}, id:\.self) {
                        searchText in Text(searchText)
                    }
                }
                .navigationBarTitle(Text("Search"))
                .resignKeyboardOnDragGesture()
            }
        }
    }
}

#Preview {
    SearchBarContentView()
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
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

struct SearchBarView: View {
    
    
    @Binding var searchText: String
    @State private var showCancelButton: Bool = false
    @State private var showAdvancedSearch: Bool = false
    
    @State private var selectedCriteriaConjunction: String = "AND"
    let criteriaConjunction = ["AND", "OR", "NOT"]
    
    @State private var selectedField: String = "AND"
    let fieldOptions: [String]

    @State private var selectedCondition: String = "file_name"
    
    var conditionOptions: [String] {
        guard let fieldType = sampleSearchFiltersDict[selectedField]?.fieldType else { return SearchFilter.FieldTypes.Other.getAllCases() }
        return fieldType.getAllCases()
    }
    

    
    @State private var keyward: String = ""
    
    var onCommit: () ->Void = {print("onCommit")}
    
    init(searchText: Binding<String>, onCommit: @escaping () -> Void) {
        self._searchText = searchText
        self.onCommit = onCommit
        self.fieldOptions = Array(sampleSearchFiltersDict.keys)
    }
    
    private func performAdvancedSearch() {
        // Construct the search criteria
        let searchText = SearchFilter.createSearchCriteria(
            conjunction: SearchFilter.Conjunction(rawValue: selectedCriteriaConjunction) ?? .and,
            fieldId: sampleSearchFiltersDict[selectedField]?.fieldId ?? "",
            condition: SearchFilter.OtherField(rawValue: selectedCondition) ?? .equals,
            value: keyward
        )

        // Perform the search
        advancedSearch(search: searchText, directory: "/", verbose: true) { assetsInfo in
            // Handle the search results
            if let firstResult = assetsInfo?.first {
                logger.info("First result name: \(firstResult.id)")
            } else {
                logger.info("No results found")
            }
        }
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
                
                // Clear button
                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                }
                // AdvancedSearch button
                Button(action: {
                    //                    self.searchText = ""
                    self.showAdvancedSearch.toggle()
                }) {
                    Image(systemName: "ellipsis.circle")
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary) // For magnifying glass and placeholder test
            .background(Color(.tertiarySystemFill))
            .cornerRadius(10.0)
            
            if showCancelButton  {
                // Cancel button
                Button("Cancel") {
                    UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                    self.searchText = ""
                    self.showCancelButton = false
                }
                .foregroundColor(Color(.systemBlue))
            }
            
        }
        .padding(.horizontal)
        //        .navigationBarHidden(showCancelButton)
        
        // Advanced search fields
        if showAdvancedSearch {
            List {
                Picker(selection: $selectedCriteriaConjunction, label: Text("Criteria Conjunction")) {
                    ForEach(criteriaConjunction, id: \.self) { item in
                        Text(item).foregroundColor(.black)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Picker(selection: $selectedField, label: Text("Select Field")) {
                    ForEach(fieldOptions, id: \.self) { item in
                        Text(item).foregroundColor(.black)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Picker(selection: $selectedCondition, label: Text("Select Condition")) {
                    ForEach(conditionOptions, id: \.self) { item in
                        Text(item).foregroundColor(.black)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                
                TextField("Keyward", text: $keyward)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack {
                    Spacer()
                    
                    Button("Advanced Search") {
                        performAdvancedSearch()
                    }
                    .foregroundColor(Color(.systemBlue))
                }
                
            }
            .listRowInsets(EdgeInsets())
            
        }
        
    }
    
    
        // You can add more fields here...
//        .transition(.move(edge: .top)) // This
//        .foregroundColor(.secondary)
//        .background(Color(.tertiarySystemFill))
//        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
    
}
