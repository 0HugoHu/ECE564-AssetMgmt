import Foundation
import SwiftUI

class DocumentFieldsViewModel: ObservableObject {
    @Published var dcFields: Fields
    @Published var id: Int
    @Published var isEditing: Bool = false

    init(dcFields: Fields, id: Int) {
        self.dcFields = dcFields
        self.id = id
    }

    func toggleEditing() {
        isEditing.toggle()
    }
    
    func updateDC() {
        let customJSON = dcFields.toCustomJSON(id: id)
        updateDublinCore(customJSON: customJSON) { success in
            if success {
                print("Update successful")
                // Handle successful update here
            } else {
                print("Update failed")
                // Handle failure here
            }
        }
    }
}

struct DCSectionView: View {
    @ObservedObject var viewModel: DocumentFieldsViewModel
    
    var body: some View {
        Section(header: Text("Dublin Core Metadata")) {
            if viewModel.isEditing {
                editableFields
            } else {
                displayFields
            }
            editButton
        }
    }

    private var displayFields: some View {
        Group {
            let fields = [
                viewModel.dcFields.title?.joined(separator: ", "),
                viewModel.dcFields.description,
                viewModel.dcFields.keyword?.joined(separator: ", "),
                viewModel.dcFields.creator?.joined(separator: ", "),
                viewModel.dcFields.rights?.joined(separator: ", "),
                viewModel.dcFields.contributor?.joined(separator: ", "),
                viewModel.dcFields.publisher?.joined(separator: ", "),
                viewModel.dcFields.coverage,
                viewModel.dcFields.date?.joined(separator: ", "),
                viewModel.dcFields.identifier,
                viewModel.dcFields.source,
                viewModel.dcFields.format
            ]
            
            let allFieldsEmpty = fields.compactMap { $0 }.allSatisfy { $0.isEmpty }
            
            if allFieldsEmpty {
                
                HStack {
                    Spacer()
                    Text("No values available for any fields")
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
            } else {
                
                // Display each field
                displayField("Title", value: viewModel.dcFields.title?.joined(separator: ", "))
                displayField("Description", value: viewModel.dcFields.description)
                displayField("Keywords", value: viewModel.dcFields.keyword?.joined(separator: ", "))
                displayField("Creators", value: viewModel.dcFields.creator?.joined(separator: ", "))
                displayField("Rights", value: viewModel.dcFields.rights?.joined(separator: ", "))
                displayField("Contributors", value: viewModel.dcFields.contributor?.joined(separator: ", "))
                displayField("Publisher", value: viewModel.dcFields.publisher?.joined(separator: ", "))
                displayField("Coverage", value: viewModel.dcFields.coverage)
                displayField("Date", value: viewModel.dcFields.date?.joined(separator: ", "))
                displayField("Identifier", value: viewModel.dcFields.identifier)
                displayField("Source", value: viewModel.dcFields.source)
                displayField("Format", value: viewModel.dcFields.format)
                
            }
        }
    }
    
    private func displayField(_ key: String, value: String?) -> some View {
        Group {
            if let value = value {
                DocumentAttributeRow(key: key, value: value)
            }
        }
    }

    private var editButton: some View {
        HStack {
            Spacer() // Pushes the button to the trailing edge
            Button(action: {
                if viewModel.isEditing {
                    viewModel.updateDC() // Call updateDC when saving
                }
                viewModel.toggleEditing()
            }) {
                Text(viewModel.isEditing ? "Save" : "Edit")
                    .foregroundColor(viewModel.isEditing ? .red : .blue)
            }
        }
    }
    
    private var editableFields: some View {
        VStack {
            editableArrayField("Title", array: Binding<[String]>(
                get: { self.viewModel.dcFields.title ?? [] },
                set: { newValue in self.viewModel.dcFields.title = newValue.isEmpty ? nil : newValue }
            ))

            editableStringField("Description", text: Binding<String>(
                get: { self.viewModel.dcFields.description ?? "" },
                set: { newValue in self.viewModel.dcFields.description = newValue.isEmpty ? nil : newValue }
            ))
            
            editableArrayField("Keyword", array: Binding<[String]>(
                get: { self.viewModel.dcFields.keyword ?? [] },
                set: { newValue in self.viewModel.dcFields.keyword = newValue.isEmpty ? nil : newValue }
            ))
            
            editableArrayField("Creator", array: Binding<[String]>(
                get: { self.viewModel.dcFields.creator ?? [] },
                set: { newValue in self.viewModel.dcFields.creator = newValue.isEmpty ? nil : newValue }
            ))
            
            editableArrayField("Rights", array: Binding<[String]>(
                get: { self.viewModel.dcFields.rights ?? [] },
                set: { newValue in self.viewModel.dcFields.rights = newValue.isEmpty ? nil : newValue }
            ))
            
            editableArrayField("Contributor", array: Binding<[String]>(
                get: { self.viewModel.dcFields.contributor ?? [] },
                set: { newValue in self.viewModel.dcFields.contributor = newValue.isEmpty ? nil : newValue }
            ))
            
            editableArrayField("Publisher", array: Binding<[String]>(
                get: { self.viewModel.dcFields.publisher ?? [] },
                set: { newValue in self.viewModel.dcFields.publisher = newValue.isEmpty ? nil : newValue }
            ))
            
            editableStringField("Coverage", text: Binding<String>(
                get: { self.viewModel.dcFields.coverage ?? "" },
                set: { newValue in self.viewModel.dcFields.coverage = newValue.isEmpty ? nil : newValue }
            ))
            
            editableArrayField("Date", array: Binding<[String]>(
                get: { self.viewModel.dcFields.date ?? [] },
                set: { newValue in self.viewModel.dcFields.date = newValue.isEmpty ? nil : newValue }
            ))
            
            editableStringField("Identifier", text: Binding<String>(
                get: { self.viewModel.dcFields.identifier ?? "" },
                set: { newValue in self.viewModel.dcFields.identifier = newValue.isEmpty ? nil : newValue }
            ))
            
            editableStringField("Source", text: Binding<String>(
                get: { self.viewModel.dcFields.source ?? "" },
                set: { newValue in self.viewModel.dcFields.source = newValue.isEmpty ? nil : newValue }
            ))
            
            editableStringField("Format", text: Binding<String>(
                get: { self.viewModel.dcFields.source ?? "" },
                set: { newValue in self.viewModel.dcFields.format = newValue.isEmpty ? nil : newValue }
            ))
        }
    }

    private func editableArrayField(_ label: String, array: Binding<[String]>) -> some View {
        HStack {
            Text(label)
            Spacer()
            TextField(label, text: Binding<String>(
                get: { array.wrappedValue.joined(separator: ", ") },
                set: { newValue in array.wrappedValue = newValue.components(separatedBy: ", ") }
            ))
            .multilineTextAlignment(.trailing)
            .frame(maxWidth: .infinity)
        }
    }

    private func editableStringField(_ label: String, text: Binding<String>) -> some View {
        HStack {
            Text(label)
            Spacer()
            TextField(label, text: text)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity)
        }
    }
}
