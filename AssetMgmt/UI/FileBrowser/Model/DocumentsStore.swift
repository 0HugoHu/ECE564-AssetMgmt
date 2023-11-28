import Foundation
import Combine
import SwiftUI

enum DocumentsStoreError: Error, LocalizedError {
    case fileExists
    case fileWasDeleted
    case remoteCreationSuccedded
    case remoteRenameSuccedded
    case unknown
}

enum ViewMode: String, Codable, CaseIterable {
    case list
    case grid
}

protocol DocumentImporter {
    func importFile(from url: URL) async
}

@MainActor
public class DocumentsStore: ObservableObject, DocumentImporter {
    var uploadProgress: Binding<Double>? = nil
    var loading: Binding<Bool>? = nil
    @Published var documents: [Document] = []
    @Published var sorting: SortOption = .date(ascending: false)
    @Published var viewMode: ViewMode = .list {
        didSet {
            saveViewModeToUserDefaults()
        }
    }
    
    var docDirectory: URL
    var remoteUrl : String
    var mode: FileBrowserMode
    private var relativePath: String
    private var documentManager: DocumentManager
    private let attrKeys: [URLResourceKey] = [.nameKey, .fileSizeKey, .contentModificationDateKey, .creationDateKey, .isDirectoryKey]
    
    private var workingDirectory: URL {
        guard relativePath.count > 0 else {
            return docDirectory
        }
        
        return docDirectory.appendingPathComponent(relativePath)
    }
    
    private var confirmedDeleteFoldersNotification : NSObjectProtocol? = nil
    
    public init(
        root: URL,
        relativePath: String = "",
        sorting: SortOption = .date(ascending: false),
        documentsSource: DocumentManager = FileManager.default
    ) {
        docDirectory = root
        self.mode = .local
        self.relativePath = relativePath
        if let loadedSortOption = SortOption.loadFromUserDefaults() {
            self.sorting = loadedSortOption
        } else {
            self.sorting = sorting
        }
        self.documentManager = documentsSource
        self.remoteUrl = ""
        loadViewModeFromUserDefaults()
    }
    
    init(
        root: String,
        mode: FileBrowserMode,
        relativePath: String = "",
        sorting: SortOption = .date(ascending: false)
    ) {
        docDirectory = URL(string: root)!
        self.remoteUrl = root
        self.mode = mode
        self.relativePath = relativePath
        if let loadedSortOption = SortOption.loadFromUserDefaults() {
            self.sorting = loadedSortOption
        } else {
            self.sorting = sorting
        }
        self.documentManager = FileManager.default
        loadViewModeFromUserDefaults()
    }
    
    func initNotification(documentName : String) {
        confirmedDeleteFoldersNotification = NotificationCenter.default.addObserver(forName: Notification.Name("ConfirmedDeleteFolders"), object: nil, queue: .main) { notification in
            if let folderId = notification.object as? Int {
                DispatchQueue.main.async {
                    deleteFiles(paths: [(self.relativePath == "" ? self.remoteUrl : self.relativePath + "/") + documentName]) { response in
                        switch response {
                        case true:
                            self.removeDocument(folderId)
                            logger.info("Observer ConfirmedDeleteFolders called")
                        case false:
                            NotificationCenter.default.post(name: Notification.Name("DeleteFailed"), object: nil)
                            logger.info("Failed to delete folder")
                        }
                    }
                    NotificationCenter.default.removeObserver(self.confirmedDeleteFoldersNotification!)
                }
            }
        }
    }
    
    fileprivate func document(from url: URL) -> Document? {
        var document: Document? = nil
        do {
            let attrVals = try url.resourceValues(forKeys: Set(attrKeys))
            let fileName = attrVals.name ?? ""
            let created = attrVals.creationDate
            let modified = attrVals.contentModificationDate
            let size = NSNumber(value: attrVals.fileSize ?? 0)
            let isDirectory = attrVals.isDirectory ?? false
            
            document = Document(name: fileName, url: url, size: size, created: created, modified: modified, isDirectory: isDirectory)
        } catch let error as NSError {
            NSLog("Error reading file attr: \(error)")
        }
        return document
    }
    
    func loadDocuments() {
        if let loading = loading {
            loading.wrappedValue = true
        }
        if self.mode == .local {
            do {
                let allFiles = try documentManager.contentsOfDirectory(at: workingDirectory)
                documents = allFiles.map { document(from: $0) }.compactMap{ $0 }
            } catch let error as NSError {
                NSLog("Error traversing files directory: \(error)")
            }
        } else if self.mode == .remote{
            documents.removeAll()
            // Load all directories
            let finalPath = self.relativePath == "" ? self.remoteUrl : self.relativePath
            showDirectory(path: finalPath, depth: 1, justChildren: false) { directories in
                if let directories = directories {
                    let parentFolderId = directories[0].id
                    for i in 1..<directories.count {
                        let folder = directories[i]
                        let doc = Document(mediaBeaconID: folder.id, name: folder.name, url: URL(string: folder.path)!, size: 0, type: "folder", isDirectory: true)
                        self.appendDocument(doc)
                    }
                    if directories.count > 1 {
                        if let loading = self.loading {
                            loading.wrappedValue = false
                        }
                    }
                    // Then load all files
                    let searchText = SearchFilter.createSearchCriteria(conjunction: .and, fieldId: "directory_id", condition: SearchFilter.OtherField.equals, value: String(parentFolderId))
                    advancedSearch(search: searchText, directory: finalPath, verbose: true) { files in
                        if files == nil {
                            logger.info("No file exists at \(self.remoteUrl)")
                            return
                        }
                        for file in files! {
                            let doc = Document(mediaBeaconID: file.id, name: file.name, url: URL(string: getThumbnailURL(originalURLString: file.previews.thumbnail))!, size: file.bytes as NSNumber, modified: Date(timeIntervalSince1970: file.lastModified / 1000.0), highQualityPreviewUrl: file.previews.high, type: file.mimeType ?? "unkown", isDirectory: false)
                            self.appendDocument(doc)
                        }
                        if let loading = self.loading {
                            loading.wrappedValue = false
                        }
                        self.sortDocument(0)
                    }
                } else {
                    logger.info("No folder exists at \(self.remoteUrl)")
                }
            }
        }
        
        sort()
    }
    
    func reload() {
        loadDocuments()
    }
    
    
    /*
     * This method ensures that the document is appended to the documents array on the main thread.
     * Genderated by ChatGPT
     */
    var cancellables: Set<AnyCancellable> = []
    func appendDocument(_ doc: Document) {
        Just(doc)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] document in
                self?.documents.append(document)
            }
            .store(in: &cancellables)
    }
    
    
    /*
     * This method ensures that the document is inserted to the documents array on the main thread.
     * Genderated by ChatGPT
     */
    func insertDocument(_ doc: Document) {
        Just(doc)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] document in
                self?.documents.insert(document, at: 0)
            }
            .store(in: &cancellables)
    }
    
    
    /*
     * This method ensures that the document is removed from the documents array on the main thread.
     * Generated by ChatGPT
     */
    func removeDocument(_ docId: Int) {
        Just(docId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] document in
                if let index = self?.documents.firstIndex(where: { $0.mediaBeaconID == docId }) {
                    self?.documents.remove(at: index)
                }
            }
            .store(in: &cancellables)
    }
    
    
    func sortDocument(_ docId: Int) {
        Just(docId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] document in
                self?.sort()
            }
            .store(in: &cancellables)
    }
    
    
    fileprivate func sort() {
        documents.sort(by: sorting.sortingComparator())
    }
    
    func setSorting(_ sorting: SortOption) {
        self.sorting = sorting
        
        sort()
    }
    
    func delete(_ document: Document) {
        if self.mode == .local {
            do {
                try documentManager.removeItem(at: document.url)
                // Find current document and remove from documents array
                if let index = documents.firstIndex(where: { $0.url == document.url }) {
                    documents.remove(at: index)
                }
            } catch let error as NSError {
                NSLog("Error deleting file: \(error)")
            }
        } else if self.mode == .remote {
            initNotification(documentName: document.name)
            let ids = [String(document.mediaBeaconID)]
            if document.isDirectory {
                NotificationCenter.default.post(name: Notification.Name("BlockingDeleteFolders"), object: document.mediaBeaconID)
            } else {
                deleteFiles(ids: ids) { response in
                    switch response {
                    case true:
                        self.removeDocument(document.mediaBeaconID)
                        removeFileById(String(document.mediaBeaconID))
                        logger.info("Successfully deleted file")
                    case false:
                        NotificationCenter.default.post(name: Notification.Name("DeleteFailed"), object: nil)
                        logger.info("Failed to delete file")
                    }
                }
            }
        }
    }
    
    @discardableResult
    func createNewFolder() throws -> Document {
        var folderName = "New Folder"
        var folderNumber = 0
        
        if self.mode == .local {
            var folderUrl = workingDirectory.appendingPathComponent(folderName, isDirectory: true)
            // Check if a folder with the name already exists
            while documentManager.fileExists(atPath: folderUrl.relativePath) {
                folderNumber += 1
                folderName = "New Folder (\(folderNumber))"
                folderUrl = workingDirectory.appendingPathComponent(folderName, isDirectory: true)
            }
            
            // Create the new folder
            do {
                return try createFolder(folderName)
            } catch {
                print("Error creating new folder \(error)")
                throw DocumentsStoreError.unknown
            }
        } else if self.mode == .remote {
            let folderUrl = self.relativePath == "" ? self.remoteUrl : self.relativePath
            var pathName = folderUrl + "/" + folderName + "/"
            // Check if a folder with the name already exists
            logger.error("Folder url: \(folderName)")
            while self.documents.contains(where: { $0.name == folderName }) {
                folderNumber += 1
                folderName = "New Folder (\(folderNumber))"
                pathName = folderUrl + "/" + folderName + "/"
            }
            
            // Create the new folder
            createDirectory(paths: [pathName]) { response in
                if response != nil {
                    let response = response![0]
                    let doc = Document(mediaBeaconID: response.id, name: response.name, url: URL(string: response.path)!, size: 0, isDirectory: true)
                    self.insertDocument(doc)
                    logger.info("Successfully created new folder")
                } else {
                    logger.info("Failed to create new folder")
                }
            }
            throw DocumentsStoreError.remoteCreationSuccedded
        } else {
            throw DocumentsStoreError.unknown
        }
    }
    
    @discardableResult
    func createFolder(_ name: String) throws -> Document {
        let target = workingDirectory.appendingPathComponent(name, isDirectory: true)
        do {
            try documentManager.createDirectory(at: target)
        } catch CocoaError.fileWriteFileExists {
            throw DocumentsStoreError.fileExists
        }
        
        if let folder = document(from: target) {
            documents.insert(folder, at: 0)
            sort()
            return folder
        } else {
            throw DocumentsStoreError.unknown
        }
    }
    
    func importFile(from url: URL) {
        if self.mode == .local {
            var suitableUrl = workingDirectory.appendingPathComponent(url.lastPathComponent)
            
            var retry = true
            var retryCount = 1
            while retry {
                retry = false
                
                do {
                    try documentManager.copyItem(at: url, to: suitableUrl)
                    
                    if let document = document(from: suitableUrl) {
                        documents.insert(document, at: self.documents.endIndex)
                        sort()
                    }
                } catch CocoaError.fileWriteFileExists {
                    retry = true
                    
                    // append (1) to file name
                    let fileExtension = url.pathExtension
                    let fileNameWithoutExtension = url.deletingPathExtension().lastPathComponent
                    let fileNameWithCountSuffix = fileNameWithoutExtension.appending(" (\(retryCount))")
                    suitableUrl = workingDirectory.appendingPathComponent(fileNameWithCountSuffix).appendingPathExtension(fileExtension)
                    
                    retryCount += 1
                    
                    NSLog("Retry *** suitableName = \(suitableUrl.lastPathComponent)")
                } catch let error as NSError {
                    NSLog("Error importing file: \(error)")
                }
            }
        } else if self.mode == .remote {
            let currentDirectory = self.relativePath == "" ? self.remoteUrl : self.relativePath
            if let uploadProgress = uploadProgress {
                uploadProgress.wrappedValue = 0.01
            }
            uploadFiles(filePaths: [url], dest: currentDirectory, uploadProgress: uploadProgress, completion: { result in })
        }
    }
    
    func relativePath(for document: Document) -> String {
        let url = URL(fileURLWithPath: document.name, isDirectory: document.isDirectory, relativeTo: URL(fileURLWithPath: "/\(relativePath)", isDirectory: true)).path
        return url
    }
    
    @discardableResult
    func rename(document: Document, newName: String) throws -> Document {
        if self.mode == .local {
            let newUrl = workingDirectory.appendingPathComponent(newName, isDirectory: document.isDirectory)
            do {
                try documentManager.moveItem(at: document.url, to: newUrl)
                
                // Find current document in documents array and update the values
                if let indexToUpdate = documents.firstIndex(where: { $0.url == document.url }) {
                    var documentToUpdate = documents[indexToUpdate]
                    documents.remove(at: indexToUpdate)
                    
                    documentToUpdate.url = newUrl
                    documentToUpdate.name = newName
                    documents.insert(documentToUpdate, at: 0)
                    
                    sort()
                    return documentToUpdate
                } else {
                    throw DocumentsStoreError.fileWasDeleted
                }
            } catch CocoaError.fileWriteFileExists {
                throw DocumentsStoreError.fileExists
            }
        } else if self.mode == .remote {
            if let renameIndex = documents.firstIndex(where: { $0.mediaBeaconID == document.mediaBeaconID }) {
                var documentToUpdate = documents[renameIndex]
                
                if document.isDirectory {
                    renameFiles(paths: [(self.relativePath == "" ? self.remoteUrl : self.relativePath + "/") + document.name], newNames: [newName]) { response in
                        switch response {
                        case true:
                            self.removeDocument(document.mediaBeaconID)
                            documentToUpdate.name = newName
                            self.insertDocument(documentToUpdate)
                            logger.info("Successfully renamed folder")
                        case false:
                            logger.info("Failed to rename folder")
                        }
                    }
                } else {
                    renameFiles(ids: [document.mediaBeaconID], newNames: [newName]) { response in
                        switch response {
                        case true:
                            self.removeDocument(document.mediaBeaconID)
                            documentToUpdate.name = newName
                            self.insertDocument(documentToUpdate)
                            logger.info("Successfully renamed file")
                        case false:
                            logger.info("Failed to rename file")
                        }
                    }
                }
            } else {
                throw DocumentsStoreError.fileWasDeleted
            }
            
            throw DocumentsStoreError.remoteRenameSuccedded
        } else {
            throw DocumentsStoreError.unknown
        }
    }
    
    private func saveViewModeToUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(viewMode.rawValue, forKey: "ViewMode")
    }
    
    private func loadViewModeFromUserDefaults() {
        let defaults = UserDefaults.standard
        if let rawValue = defaults.string(forKey: "ViewMode"),
           let loadedViewMode = ViewMode(rawValue: rawValue) {
            viewMode = loadedViewMode
        }
    }
    
    func getRelativePath() -> String {
        return relativePath
    }
}

class DocumentsStore_Preview: DocumentsStore {
    override var documents: [Document] {
        set {
            super.documents = newValue
        }
        get {
            return  [Document(name: "Hello.pdf", url: URL(string: "/")!, size:1700, modified: Date()),
                     Document(name: "Travel documentation list.txt", url: URL(string: "/")!, size:100000, modified: Date().addingTimeInterval(-30000))]
        }
    }
}
