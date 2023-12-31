//
//  StringAttributeRow.swift
//  AssetMgmt
//
//  Created by Minghui ZHU on 11/27/23.
//

import Foundation
import SwiftUI

struct SingleStringAttributeRow: View {
    @State var id: Int
    @State var key: String
    @Binding var value: String
    @State private var showingEditSheet = false
    
    init(id: Int, key: String, value: Binding<String>) {
        self.id = id
        self.key = key
        self._value = value
    }
    
    var body: some View {
        HStack {
            Text(key)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
                .foregroundColor(.secondary)
        }
        .swipeActions {
            if !isSwipeDisabled(for: key) {
                Button("Edit") {
                    showingEditSheet = true
                }
                .tint(.blue)
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditSingleStringView(id: id, key: key, value: $value)
        }
    }
    
    private func isSwipeDisabled(for key: String) -> Bool {
        return key == "Identifier" || key == "Format"
    }
}

struct ListStringAttributeRow: View {
    @State var id: Int
    @State var key: String
    @Binding var values: [String]
    @State private var showingEditSheet = false
    
    init(id: Int, key: String, values: Binding<[String]>) {
        self.id = id
        self.key = key
        self._values = values
    }
    
    var body: some View {
        HStack {
            Text(key)
            Spacer()
            VStack(alignment: .trailing) {
                ForEach(values, id: \.self) { value in
                    Text(value)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
        .swipeActions {
            if !isSwipeDisabled(for: key) {
                Button("Edit") {
                    showingEditSheet = true
                }
                .tint(.blue)
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditStringListView(id: id, key: key, values: $values)
        }
    }
    
    private func isSwipeDisabled(for key: String) -> Bool {
        return key == "Identifier" || key == "Format"
    }
}


struct EditSingleStringView: View {
    @State var id: Int
    @State var key: String
    @Binding var value: String
    @Environment(\.presentationMode) var presentationMode
    @State private var tempValue: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Edit \(key)", text: $tempValue)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onAppear {
                        tempValue = value
                    }
                
                Spacer()
            }
            .navigationBarTitle("Edit \(key)", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    value = tempValue
                    let customJSON = Fields().toJSONField(id: id, key: key, value: value)
                    print(customJSON)
                    updateDublinCore(customJSON: customJSON) { success in
                        if success {
                            print("Update successful")
                        } else {
                            print("Update failed")
                        }
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct EditStringListView: View {
    @State var id: Int
    @State var key: String
    @Binding var values: [String]
    @State private var newItem: String = ""
    @State private var newDate: Date = Date()
    @Environment(\.presentationMode) var presentationMode
    @State private var tempValues: [String] = []
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach($tempValues.indices, id: \.self) { index in
                        if key == "Date" {
                            DatePicker("Select Date", selection: Binding(
                                get: { self.getDateFromString(self.tempValues[index]) ?? Date() },
                                set: { self.tempValues[index] = self.getStringFromDate($0) }
                            ), displayedComponents: .date)
                        } else {
                            TextField("Edit Value", text: $tempValues[index])
                        }
                    }
                    .onDelete(perform: delete)
                }
                .onAppear {
                    tempValues = values
                }
                
                if key == "Date" {
                    DatePicker("New Date", selection: $newDate, displayedComponents: .date)
                        .padding()
                    
                    Button("Add New Date") {
                        addNewDate()
                    }
                } else {
                    HStack {
                        TextField("New Item", text: $newItem)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(action: addNewItem) {
                            Text("Add")
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitle("Edit \(key)", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    values = tempValues
                    let customJSON = Fields().toJSONField(id: id, key: key, value: values)
                    print(customJSON)
                    updateDublinCore(customJSON: customJSON) { success in
                        if success {
                            print("Update successful")
                        } else {
                            print("Update failed")
                        }
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func addNewItem() {
        if !newItem.isEmpty {
            tempValues.append(newItem)
            newItem = ""
        }
    }
    
    private func addNewDate() {
        let newDateString = getStringFromDate(newDate)
        tempValues.append(newDateString)
        newDate = Date()
    }
    
    private func delete(at offsets: IndexSet) {
        tempValues.remove(atOffsets: offsets)
    }
    
    private func getDateFromString(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: string)
    }
    
    private func getStringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
