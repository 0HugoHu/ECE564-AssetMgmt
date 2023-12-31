//
//  DocumentRow.swift
//  AssetMgmt
//
//  Created by ntsh (https://github.com/ntsh/DirectoryBrowser)
//  Adapted by Hugooooo on 11/5/23.
//

import FilePreviews
import SwiftUI

struct DocumentRow: View {
    @Binding var document: Document
    var shouldEdit: Bool = false
    @ObservedObject var documentsStore: DocumentsStore
    
    @State private var isEditing = false
    @FocusState private var nameEditIsFocused: Bool
    @State private var documentNameErrorMessage: String?
    // Store the original document
    @State private var originalDocument: Document
    
    // Initialize the view with the original document
    init(document: Binding<Document>, shouldEdit: Bool = false, documentsStore: DocumentsStore) {
        self._document = document
        self.shouldEdit = shouldEdit
        self.documentsStore = documentsStore
        self._originalDocument = State(initialValue: document.wrappedValue)
    }
    
    var body: some View {
        HStack (alignment: .center, spacing: 16) {
            if documentsStore.mode == .local {
                ThumbnailView(url: document.url)
                    .frame(width: 60, height: 60, alignment: .center)
                    .clipped()
                    .cornerRadius(8)
            } else if documentsStore.mode == .remote {
                AssetThumbnailViewRow(url: document.url.absoluteString)
                    .frame(width: 60, height: 60, alignment: .center)
                    .clipped()
                    .cornerRadius(8)
            }
            
            if isEditing {
                editDocumentView
            } else {
                documentSummaryView
            }
        }
        .contextMenu {
            Button(action: deleteDocument) {
                Label("Delete", systemImage: "trash")
            }
            Button(action: {
                isEditing = true
            }) {
                Label("Rename", systemImage: "pencil")
            }
        }
        .onChange(of: isEditing) {
            nameEditIsFocused = $0
        }
        .onAppear {
            isEditing = shouldEdit
        }
    }
    
    private var editDocumentView: some View {
        HStack {
            VStack(alignment: .leading) {
                TextField("Name", text: $document.name, prompt: nil)
                    .focused($nameEditIsFocused)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit(renameDocument)
                
                if let errMsg = documentNameErrorMessage {
                    HStack(spacing: 4) {
                        Image(systemName: "exclamationmark.circle.fill")
                        Text(errMsg).font(.callout)
                    }
                    .foregroundColor(.red)
                    .padding(.bottom)
                }
            }
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 32, height: 32)
                .foregroundColor(.accentColor)
                .padding()
                .onTapGesture(perform: renameDocument)
        }
    }
    
    private var documentSummaryView: some View {
        VStack(alignment: .leading, spacing: 12 ) {
            Text(document.name)
                .font(.headline)
                .lineLimit(2)
                .allowsTightening(true)
            
            if let modified = document.modified {
                Text(modified.formatted())
                    .font(.subheadline)
                    .lineLimit(1)
                    .allowsTightening(true)
                    .minimumScaleFactor(0.5)
            }
        }
    }
    
    private func renameDocument() {
        withAnimation {
            documentNameErrorMessage = nil
            do {
                try documentsStore.rename(document: originalDocument, newName: document.name)
                isEditing = false
            } catch DocumentsStoreError.fileExists {
                withAnimation {
                    documentNameErrorMessage = "Document already exists"
                }
            } catch DocumentsStoreError.remoteRenameSuccedded {
                isEditing = false
            } catch {
                print("Unexpected error during rename: \(error)")
                documentNameErrorMessage = "Unexpected error"
            }
        }
    }
    
    private func deleteDocument() {
        withAnimation {
            documentsStore.delete(document)
        }
    }
}


