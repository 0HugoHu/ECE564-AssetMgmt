//
//  DocumentGrid.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/12/23.
//

import FilePreviews
import SwiftUI

struct DocumentGrid: View {
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
        VStack (alignment: .center, spacing: 4) {
            if documentsStore.mode == .local {
                ThumbnailView(url: document.url)
                    .frame(width: 80, height: 80, alignment: .center)
                    .clipped()
                    .cornerRadius(8)
            } else if documentsStore.mode == .remote {
                AssetThumbnailViewGridNew(url: document.url.absoluteString)
                    .frame(width: 80, height: 80, alignment: .center)
                    .clipped()
                    .cornerRadius(8)
            }
            
            if isEditing {
                editDocumentView
            } else {
                documentSummaryView
            }
        }
        .padding(8)
        .contextMenu {
            Button(action: deleteDocument) {
                Label("Delete", systemImage: "trash")
            }
            Button(action: {
                isEditing = true
            }) {
                Label("Rename", systemImage: "pencil")
            }
            Button(action: {}) {
                Label("Move", systemImage: "folder.badge.gear")
            }
            Button(action: {}) {
                Label("Share", systemImage: "square.and.arrow.up")
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
                    .font(Font.system(size: 14))
                
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
                .frame(width: 16, height: 16)
                .foregroundColor(.accentColor)
                .onTapGesture(perform: renameDocument)
        }
    }
    
    private var documentSummaryView: some View {
        VStack(alignment: .leading) {
            Text(document.name)
                .font(Font.system(size: 14))
                .lineLimit(2)
                .allowsTightening(true)
                .foregroundColor(.black)
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

struct DocumentGrid_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DocumentRow(
                document: .constant(DocumentsStore_Preview(
                    root: URL.temporaryDirectory,
                    relativePath: "/", sorting: .date(ascending: true)
                ).documents[1]),
                documentsStore: DocumentsStore_Preview(root: URL.temporaryDirectory)
            )
            .environment(\.sizeCategory, .large)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
        }
    }
}
