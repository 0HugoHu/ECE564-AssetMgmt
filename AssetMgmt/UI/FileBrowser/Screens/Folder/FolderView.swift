import SwiftUI

public struct FolderView: View {
    @State var isPresentedPicker = false
    @State var isPresentedPhotoPicker = false
    @State var listProxy: ScrollViewProxy? = nil
    @State var lastCreatedNewFolder: Document?
    
    @ObservedObject var documentsStore: DocumentsStore
    var title: String
    
    @ViewBuilder
    var listSectionHeader: some View {
        Text("All")
            .background(Color.clear)
    }
    
    fileprivate func sortByDateButton() -> some View {
        let sortImage: String = documentsStore.sorting.dateButtonIcon()
        return Label("     Date", systemImage: sortImage)
    }
    
    fileprivate func sortByNameButton() -> some View {
        let sortImage: String =  documentsStore.sorting.nameButtonIcon()
        return Label("     Name", systemImage: sortImage)
    }
    
    fileprivate func sortByTypeButton() -> some View {
        let sortImage: String =  documentsStore.sorting.typeButtonIcon()
        return Label("     Type", systemImage: sortImage)
    }
    
    fileprivate func getGridModeLabel() -> some View {
        switch documentsStore.viewMode {
        case .grid:
            return Label("✓  Icons", systemImage: "square.grid.2x2")
        case .list:
            return Label("     Icons", systemImage: "square.grid.2x2")
        }
    }
    
    fileprivate func getListModeLabel() -> some View {
        switch documentsStore.viewMode {
        case .grid:
            return Label("     List", systemImage: "list.bullet")
        case .list:
            return Label("✓  List", systemImage: "list.bullet")
        }
    }
    
    var actionButtons: some View {
        HStack {
            Menu {
                Button(action: { }) {
                    Label("     Select", systemImage: "checkmark.circle")
                }
                Button(action: didClickCreateFolder) {
                    Label("     New Folder", systemImage: "folder.badge.plus")
                }
                Button(action: { isPresentedPicker = true }) {
                    Label("     Import Files", systemImage: "doc.badge.arrow.up")
                }
                Button(action: { isPresentedPhotoPicker = true }) {
                    Label("     Import Photos", systemImage: "photo.on.rectangle")
                }
                Button(action: { }) {
                    Label("     Scan Documents", systemImage: "doc.text.viewfinder")
                }
                
                Divider()
                
                Button(action: { 
                    withAnimation {
                        documentsStore.viewMode = .grid
                    }
                }) {
                    getGridModeLabel()
                }
                Button(action: { 
                    withAnimation {
                        documentsStore.viewMode = .list
                    }
                }) {
                    getListModeLabel()
                }
                
                Divider()
                
                Button(action: {
                    withAnimation {
                        documentsStore.setSorting(documentsStore.sorting.toggleToNameSortOption())
                    }
                }) {
                    sortByNameButton()
                }
                Button(action: {
                    withAnimation {
                        documentsStore.setSorting(documentsStore.sorting.toggleToDateSortOption())
                    }
                }) {
                    sortByDateButton()
                }
                Button(action: {
                    withAnimation {
                        documentsStore.setSorting(documentsStore.sorting.toggleToTypeSortOption())
                    }
                }) {
                    sortByTypeButton()
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }
    
    var emptyFolderView: some View {
        VStack {
            Text("Folder is empty")
                .multilineTextAlignment(.center)
                .padding()
        }
    }
    
    public init(documentsStore: DocumentsStore, title: String) {
        self.documentsStore = documentsStore
        self.title = title
    }
    
    public var body: some View {
        ZStack {
            ScrollViewReader { scrollViewProxy in
                if documentsStore.viewMode == .list {
                    List {
                        Section(header: listSectionHeader) {
                            ForEach($documentsStore.documents) { document in
                                NavigationLink(destination: navigationDestination(for: document.wrappedValue)) {
                                    DocumentRow(
                                        document: document,
                                        shouldEdit: (document.id == lastCreatedNewFolder?.id),
                                        documentsStore: documentsStore
                                    )
                                    .padding(.vertical, 4)
                                    .id(document.id)
                                }
                            }
                            .onDelete(perform: deleteItems)
                        }
                    }
                    .listStyle(InsetListStyle())
                    .onAppear {
                        listProxy = scrollViewProxy
                    }
                    .refreshable {
                        documentsStore.reload()
                    }
                } else if documentsStore.viewMode == .grid {
                    let columns: [GridItem] = [
                        GridItem(.adaptive(minimum: 100), spacing: 0, alignment: .top)
                    ]
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach($documentsStore.documents) { document in
                                NavigationLink(destination: navigationDestination(for: document.wrappedValue)) {
                                    DocumentGrid(
                                        document: document,
                                        shouldEdit: (document.id == lastCreatedNewFolder?.id),
                                        documentsStore: documentsStore
                                    )
                                    .padding(.vertical, 4)
                                    .id(document.id)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .onAppear {
                            listProxy = scrollViewProxy
                        }
                        .refreshable {
                            documentsStore.reload()
                        }
                    }
                }
            }
            .background(Color.clear)
            .navigationBarItems(trailing: actionButtons)
            .navigationTitle(title)
            .sheet(isPresented:  $isPresentedPicker) {
                DocumentPicker(documentsStore: documentsStore) {
                    NSLog("Docupicker callback")
                }
            }
            .sheet(isPresented:  $isPresentedPhotoPicker) {
                PhotoPicker(documentsStore: documentsStore) {
                    NSLog("Imagepicker callback")
                }
            }
            
            if (documentsStore.documents.isEmpty) {
                emptyFolderView
            }
        }
        .task {
            documentsStore.loadDocuments()
        }
    }
    
    @ViewBuilder
    private func navigationDestination(for document: Document) -> some View {
        if document.isDirectory {
            if documentsStore.mode == .local {
                let relativePath = documentsStore.relativePath(for: document)
                FolderView(
                    documentsStore: DocumentsStore(
                        root: documentsStore.docDirectory,
                        relativePath: relativePath,
                        sorting: documentsStore.sorting
                    ),
                    title: document.name
                )
            } else if documentsStore.mode == .remote {
                let relativePath = "/" + document.name
                FolderView(
                    documentsStore: DocumentsStore(
                        root: documentsStore.remoteUrl,
                        mode: .remote,
                        relativePath: relativePath
                    ),
                    title: document.name
                )
            }
        } else {
            DocumentDetails(document: document, mode: documentsStore.mode)
        }
    }
    
    func didClickCreateFolder() {
        NSLog("Did click create folder")
        do {
            lastCreatedNewFolder = try documentsStore.createNewFolder()
            if let lastCreatedNewFolder {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
                    withAnimation {
                        listProxy?.scrollTo(lastCreatedNewFolder.id, anchor: .top)
                    }
                }
            }
        } catch {
            switch error {
            case DocumentsStoreError.remoteCreationSuccedded:
                logger.error("\(documentsStore.documents.last?.name ?? "unknown") created remotely")
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
                    withAnimation {
                        listProxy?.scrollTo(documentsStore.documents.last?.id, anchor: .bottom)
                    }
                }
            default:
                break
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        offsets
            .map { documentsStore.documents[$0] }
            .forEach { deleteDocument($0) }
    }
    
    private func deleteDocument(_ document: Document) {
        withAnimation {
            documentsStore.delete(document)
        }
    }
}

import FilePreviews

struct FolderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FolderView(documentsStore: DocumentsStore_Preview(root: URL.temporaryDirectory, relativePath: "/", sorting: .date(ascending: true)), title: "Docs")
                .environmentObject(Thumbnailer())
        }
    }
}
