//
//  FolderView.swift
//  AssetMgmt
//
//  Created by ntsh (https://github.com/ntsh/DirectoryBrowser)
//  Adapted by Hugooooo on 11/3/23.
//

import SwiftUI

public struct FolderView: View {
    @State var isPresentedPicker = false
    @State var isPresentedPhotoPicker = false
    @State var listProxy: ScrollViewProxy? = nil
    @State var lastCreatedNewFolder: Document?
    @State private var uploadProgress: Double = -1
    @State private var showPopupSuccess = false
    @State private var onlyShowPopupSuccess = false
    @State private var showPopupWarning = false
    // Folder ID used to set warning
    @State private var folderID: Int = -1
    @State private var showPopupFail = false
    @State private var loading = true
    
    @ObservedObject var documentsStore: DocumentsStore
    var title: String
    
    @ObservedObject var searchViewModel: SearchViewModel
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 100), spacing: 20)
    ]
    
    @State private var errorNotification : NSObjectProtocol? = nil
    @State private var warningNotification : NSObjectProtocol? = nil
    
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
                Button(action: didClickCreateFolder) {
                    Label("     New Folder", systemImage: "folder.badge.plus")
                }
                Button(action: {
                    isPresentedPhotoPicker = true
                    uploadProgress = -1
                    self.documentsStore.uploadProgress = $uploadProgress
                }) {
                    Label("     Upload Photos", systemImage: "photo.on.rectangle")
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
    
    var emptyFolderView = EmptyFolderView()
    
    public init(documentsStore: DocumentsStore, title: String) {
        self.documentsStore = documentsStore
        self.title = title
        self.searchViewModel = SearchViewModel(currentDirectory: documentsStore.getRelativePath())
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let smallerDimension = min(screenWidth, screenHeight)
            let circleSize = 0.25 * smallerDimension
            let centerX = screenWidth / 2
            let centerY = screenHeight / 2
            VStack (spacing: 0) {
                SearchBarView(
                    searchText: $searchViewModel.searchText,
                    selectedCriteriaConjunction: $searchViewModel.selectedCriteriaConjunction,
                    selectedField: $searchViewModel.selectedField,
                    selectedCondition: $searchViewModel.selectedCondition,
                    showAdvancedSearch: $searchViewModel.showAdvancedSearch,
                    isSearching: $searchViewModel.isSearching,
                    searchResults: $searchViewModel.searchResults,
                    selectedSearchDirectoryOption:$searchViewModel.selectedSearchDirectoryOption,
                    onCommit: {searchViewModel.search()
                        searchViewModel.updateSearchStatus()
                    },
                    onAdvancedSearch: {
                        searchViewModel.performAdvancedSearch()
                        searchViewModel.updateSearchStatus()
                    }
                )
                // As long as the search text updates, the searchStatus will update
                .onChange(of: searchViewModel.searchText) { _ in
                    if !searchViewModel.searchText.isEmpty {
                        searchViewModel.search()
                    }
                    searchViewModel.updateSearchStatus()
                }
                .onChange(of: searchViewModel.selectedSearchDirectoryOption) { _ in
                    searchViewModel.search()
                }
                Spacer()
                ZStack {
                    ZStack {
                        ScrollViewReader { scrollViewProxy in
                            if documentsStore.viewMode == .list {
                                List {
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
                                    //                                    .onDelete(perform: deleteItems)
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
                                                .padding(.vertical, 0)
                                                .id(document.id)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .onAppear {
                                        listProxy = scrollViewProxy
                                    }
                                }
                                .refreshable {
                                    documentsStore.reload()
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
                            if loading {
                                Text("Loading...")
                            } else {
                                emptyFolderView
                            }
                        }
                    }
                    
                    if searchViewModel.isSearching {
                        SearchResultsView(searchText: $searchViewModel.searchText,
                                          searchResults: $searchViewModel.searchResults,
                                          isLoading: $searchViewModel.isLoading,
                                          columns: [GridItem(.adaptive(minimum: 100), spacing: 20)])
                        .frame(maxHeight: .infinity)
                        .background(Color.white)
                        .edgesIgnoringSafeArea(.all)
                    }
                }
            }
            .task {
                loading = true
                documentsStore.loading = $loading
                documentsStore.loadDocuments()
            }
            .onChange(of: uploadProgress, perform: { newValue in
                if newValue != -1 {
                    showPopupSuccess = true
                }
            })
            .onAppear {
                self.warningNotification = NotificationCenter.default.addObserver(forName: Notification.Name("BlockingDeleteFolders"), object: nil, queue: .main) { notification in
                    if let folderId = notification.object as? Int {
                        self.folderID = folderId
                        self.showPopupWarning = true
                    }
                }
                
                self.errorNotification = NotificationCenter.default.addObserver(forName: Notification.Name("DeleteFailed"), object: nil, queue: .main) { notification in
                    self.showPopupFail = true
                }
            }
            .popup(isPresented: $showPopupSuccess) {
                VStack {
                    VStack {}
                        .frame(height: max(screenWidth, screenHeight) * 0.60 / 2)
                    
                    VStack (alignment: .center) {
                        if uploadProgress == 1 || onlyShowPopupSuccess {
                            ShineButtonWrapper (x: Int(centerX), y: Int(centerY), r: Int(circleSize), type: .success) { }
                                .offset(x: min(screenWidth, screenHeight) * 0.6 / 2 - circleSize / 2, y: 0)
                                .padding(.top, 48)
                            
                            Spacer()
                            
                            Text("Success")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.bottom, 36)
                        } else {
                            VStack {
                                Circle()
                                    .trim(from: 0, to: CGFloat(uploadProgress))
                                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                                    .rotationEffect(.degrees(-90))
                                    .padding(EdgeInsets(top: 30, leading: 30, bottom: 30, trailing: 30))
                                Spacer()
                                Text("Uploading")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .padding(.bottom, 48)
                            }
                            .frame(width: min(screenWidth, screenHeight) * 0.6, height: max(screenWidth, screenHeight) * 0.35)
                            .cornerRadius(10)
                        }
                    }
                    .background(
                        Color(UIColor { traitCollection in
                            traitCollection.userInterfaceStyle == .dark ? UIColor.systemGray6 : UIColor.systemBackground
                        })
                    )
                    .frame(width: min(screenWidth, screenHeight) * 0.6, height: max(screenWidth, screenHeight) * 0.35)
                    .cornerRadius(10)
                }
            } customize: {
                $0
                    .isOpaque(true)
                    .type(.floater())
                    .position(.top)
                    .animation(.spring())
                    .closeOnTapOutside(true)
                    .backgroundColor(.black.opacity(0.5))
            }
            .popup(isPresented: $showPopupWarning) {
                VStack {
                    VStack {}
                        .frame(height: max(screenWidth, screenHeight) * 0.60 / 2)
                    
                    VStack (alignment: .center) {
                        ShineButtonWrapper (x: Int(centerX), y: Int(centerY), r: Int(circleSize), type: .warning) {
                            
                        }
                        .offset(x: min(screenWidth, screenHeight) * 0.6 / 2 - circleSize / 2, y: 0)
                        .padding(.top, 32)
                        
                        Spacer()
                        
                        Text("This action will delete all files recursively under the folder.")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .padding(.bottom, 16)
                            .padding(.horizontal, 8)
                        
                            .padding(.horizontal, 8)
                        
                        Divider()
                            .padding(.bottom, 0)
                        
                        HStack(spacing: 20) {
                            Button(action: {
                                NotificationCenter.default.post(name: Notification.Name("ConfirmedDeleteFolders"), object: self.folderID)
                                self.showPopupWarning = false
                            }) {
                                Text("Continue")
                                    .padding()
                                    .foregroundColor(Color.red)
                                    .cornerRadius(10)
                                    .font(.caption)
                            }
                            
                            Button(action: {
                                self.showPopupWarning = false
                            }) {
                                Text("Back")
                                    .padding()
                                    .foregroundColor(.accentColor)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .background(
                        Color(UIColor { traitCollection in
                            traitCollection.userInterfaceStyle == .dark ? UIColor.systemGray6 : UIColor.systemBackground
                        })
                    )
                    .frame(width: min(screenWidth, screenHeight) * 0.6, height: max(screenWidth, screenHeight) * 0.45)
                    .cornerRadius(10)
                }
            } customize: {
                $0
                    .isOpaque(true)
                    .type(.floater())
                    .position(.top)
                    .animation(.spring())
                    .closeOnTapOutside(true)
                    .backgroundColor(.black.opacity(0.5))
            }
            .popup(isPresented: $showPopupFail) {
                VStack {
                    VStack {}
                        .frame(height: max(screenWidth, screenHeight) * 0.60 / 2)
                    
                    VStack (alignment: .center) {
                        ShineButtonWrapper (x: Int(centerX), y: Int(centerY), r: Int(circleSize), type: .error) {
                            
                        }
                        .offset(x: min(screenWidth, screenHeight) * 0.6 / 2 - circleSize / 2, y: 0)
                        .padding(.top, 48)
                        
                        Spacer()
                        
                        Text("Operation Failed")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.bottom, 36)
                    }
                    .background(
                        Color(UIColor { traitCollection in
                            traitCollection.userInterfaceStyle == .dark ? UIColor.systemGray6 : UIColor.systemBackground
                        })
                    )
                    .frame(width: min(screenWidth, screenHeight) * 0.6, height: max(screenWidth, screenHeight) * 0.35)
                    .cornerRadius(10)
                }
            } customize: {
                $0
                    .isOpaque(true)
                    .type(.floater())
                    .position(.top)
                    .animation(.spring())
                    .closeOnTapOutside(true)
                    .backgroundColor(.black.opacity(0.5))
            }
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
                let relativePath = documentsStore.getRelativePath() + "/" + document.name
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
                logger.info("\(documentsStore.documents.last?.name ?? "unknown") created remotely")
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
