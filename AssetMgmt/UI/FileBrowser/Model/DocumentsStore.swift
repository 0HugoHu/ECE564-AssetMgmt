import Foundation
import Combine

enum DocumentsStoreError: Error, LocalizedError {
    case fileExists
    case fileWasDeleted
    case unknown
}

protocol DocumentImporter {
    func importFile(from url: URL) async
}

@MainActor
public class DocumentsStore: ObservableObject, DocumentImporter {
    @Published var documents: [Document] = []
    @Published var sorting: SortOption = .date(ascending: false) //TODO: Get it from userdefaults
    
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
    
    public init(
        root: URL,
        relativePath: String = "",
        sorting: SortOption = .date(ascending: true),
        documentsSource: DocumentManager = FileManager.default
    ) {
        docDirectory = root
        self.mode = .local
        self.relativePath = relativePath
        self.sorting = sorting
        self.documentManager = documentsSource
        self.remoteUrl = ""
    }
    
    init(
        root: String,
        mode: FileBrowserMode,
        relativePath: String = "",
        sorting: SortOption = .date(ascending: true)
    ) {
        docDirectory = URL(string: root)!
        self.remoteUrl = root
        self.mode = mode
        self.relativePath = relativePath
        self.sorting = sorting
        self.documentManager = FileManager.default
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
                if directories == nil {
                    logger.info("No folder exists at \(self.remoteUrl)")
                } else {
                    var parentFolderId = 0
                    for folder in directories! {
                        let components = finalPath.split(separator: "/")
                        let lastComponent = components.count == 0 ? "/" : components[components.count - 1] + "/"
                        if folder.path ==  lastComponent{
                            parentFolderId = folder.id
                        } else {
                            let doc = Document(name: folder.name, url: URL(string: folder.path)!, size: 0, isDirectory: true)
                            self.appendDocument(doc)
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
                            let doc = Document(name: file.name, url: URL(string: getThumbnailURL(originalURLString: file.previews.thumbnail))!, size: file.bytes as NSNumber, modified: Date(timeIntervalSince1970: TimeInterval(file.lastModified)), isDirectory: false)
                            self.appendDocument(doc)
                        }
                    }
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
        // Use the receive(on:) operator to ensure this runs on the main thread
        Just(doc)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] document in
                self?.documents.append(document)
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
        do {
            try documentManager.removeItem(at: document.url)
            // Find current document and remove from documents array
            if let index = documents.firstIndex(where: { $0.url == document.url }) {
                documents.remove(at: index)
            }
        } catch let error as NSError {
            NSLog("Error deleting file: \(error)")
        }
    }
    
    @discardableResult
    func createNewFolder() throws -> Document {
        var folderName = "New Folder"
        var folderNumber = 0
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
            
        }
    }
    
    func relativePath(for document: Document) -> String {
        let url = URL(fileURLWithPath: document.name, isDirectory: document.isDirectory, relativeTo: URL(fileURLWithPath: "/\(relativePath)", isDirectory: true)).path
        return url
    }
    
    @discardableResult
    func rename(document: Document, newName: String) throws -> Document {
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
