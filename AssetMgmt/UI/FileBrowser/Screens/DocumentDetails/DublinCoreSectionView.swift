//
//  DublinCoreSectionView.swift
//  AssetMgmt
//
//  Created by Minghui ZHU on 11/27/23.
//

import Foundation
import SwiftUI

struct DCSectionView: View {
    @ObservedObject var viewModel: DocumentFieldsViewModel
    @State private var showingEmptyFields = false
    
    var body: some View {
        Section(header: Text("Dublin Core Metadata")) {
            ForEach(viewModel.fieldKeys, id: \.self) { key in
                if showingEmptyFields {
                    displayEmptyField(for: key)
                } else {
                    displayField(for: key)
                }
            }
            toggleEditButton
        }
    }
    
    private func displayField(for key: String) -> some View {
        Group {
            switch fieldType(for: key) {
            case .single:
                if let stringValue = viewModel.value(forKey: key) as? String, !stringValue.isEmpty {
                    SingleStringAttributeRow(id: viewModel.id, key: key, value: viewModel.binding(for: key, default: stringValue))
                }
            case .list:
                if let stringArray = viewModel.value(forKey: key) as? [String], !stringArray.isEmpty {
                    ListStringAttributeRow(id: viewModel.id, key: key, values: viewModel.binding(for: key, default: stringArray))
                }
            }
        }
    }

    private func displayEmptyField(for key: String) -> some View {
        Group {
            switch fieldType(for: key) {
            case .single:
                SingleStringAttributeRow(id: viewModel.id, key: key, value: viewModel.binding(for: key, default: ""))
            case .list:
                ListStringAttributeRow(id: viewModel.id, key: key, values: viewModel.binding(for: key, default: []))
            }
        }
    }

    private func fieldType(for key: String) -> FieldType {
        switch key {
        case "Title", "Description", "Coverage", "Identifier", "Source", "Format":
            return .single
        case "Keyword", "Creator", "Rights", "Contributor", "Publisher", "Date":
            return .list
        default:
            return .single // Default to single if not explicitly defined
        }
    }

    enum FieldType {
        case single
        case list
    }
    
    private var toggleEditButton: some View {
        HStack {
            Spacer()
            Button(showingEmptyFields ? "Show Valid Fields" : "Show Empty Fields") {
                showingEmptyFields.toggle()
            }
        }
    }
}
