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
    
    @State private var searchText = ""
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                // Search view
                SearchBarView(searchText: $searchText)
                
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



struct SearchBarContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchBarContentView()
                .environment(\.colorScheme, .light)
            
            SearchBarContentView()
                .environment(\.colorScheme, .dark)
        }
    }
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
    
    // States for advanced search fields
    @State private var advancedSearchField1: String = ""
    @State private var advancedSearchField2: String = ""
    
    
    var onCommit: () ->Void = {print("onCommit")}
    
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
                    self.showAdvancedSearch = true
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
            
 
                VStack {
                    HStack {
                        TextField("sortField", text: $advancedSearchField1)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        TextField("SortDirection", text: $advancedSearchField2)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding([.horizontal])
                    }
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary) // For magnifying glass and placeholder test
                    .background(Color(.tertiarySystemFill))

                }

                // You can add more fields here...

            .transition(.move(edge: .top)) // This
        }
    }
    
}


