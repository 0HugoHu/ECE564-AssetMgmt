import Foundation

public enum SortOption: Equatable {
    case date(ascending: Bool)
    case name(ascending: Bool)
    case type(ascending: Bool)
    
    // Function to save the sort option to UserDefaults
    func saveToUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(self.rawValue, forKey: "SortOption")
    }
    
    // Function to load the sort option from UserDefaults
    static func loadFromUserDefaults() -> SortOption? {
        let defaults = UserDefaults.standard
        if let rawValue = defaults.value(forKey: "SortOption") as? Int,
           let loadedSortOption = SortOption(rawValue: rawValue) {
            return loadedSortOption
        }
        return nil
    }
}

extension SortOption : RawRepresentable {
    public typealias RawValue = Int
    
    public init?(rawValue: Int) {
        switch rawValue {
        case 0:
            self = .date(ascending: true)
        case 1:
            self = .date(ascending: false)
        case 2:
            self = .name(ascending: true)
        case 3:
            self = .name(ascending: false)
        case 4:
            self = .type(ascending: true)
        case 5:
            self = .type(ascending: false)
        default:
            return nil
        }
    }
    
    public var rawValue: Int {
        switch self {
        case .date(ascending: true):
            return 0
        case .date(ascending: false):
            return 1
        case .name(ascending: true):
            return 2
        case .name(ascending: false):
            return 3
        case .type(ascending: true):
            return 4
        case .type(ascending: false):
            return 5
        }
    }
    
    func dateButtonIcon() -> String {
        sortConfigs().dateButtonIcon
    }
    
    func nameButtonIcon() -> String {
        sortConfigs().nameButtonIcon
    }
    
    func typeButtonIcon() -> String {
        sortConfigs().typeButtonIcon
    }
    
    func toggleToDateSortOption() -> SortOption {
        let sortOption = sortConfigs().toggleToDateSortOption
        sortOption.saveToUserDefaults()
        return sortOption
    }
    
    func toggleToNameSortOption() -> SortOption {
        let sortOption = sortConfigs().toggleToNameSortOption
        sortOption.saveToUserDefaults()
        return sortOption
    }
    
    func toggleToTypeSortOption() -> SortOption {
        let sortOption = sortConfigs().toggleToTypeSortOption
        sortOption.saveToUserDefaults()
        return sortOption
    }
    
    
    func sortingComparator() -> (Document, Document) -> Bool {
        return sortConfigs().comparator
    }
    
    private func sortConfigs() -> SortConfigs {
        var sortConfig: SortConfigs
        
        switch self {
        case .date(ascending: let ascending):
            sortConfig = ascending ? SortConfigs.dateAscendingSortConfigs : SortConfigs.dateDescendingSortConfigs
        case .name(ascending: let ascending):
            sortConfig = ascending ? SortConfigs.nameAscendingSortConfigs : SortConfigs.nameDescendingSortConfigs
        case .type(ascending: let ascending):
            sortConfig = ascending ? SortConfigs.typeAscendingSortConfigs : SortConfigs.typeDescendingSortConfigs
        }
        
        return sortConfig
    }
    
    private struct SortConfigs {
        var dateButtonIcon: String = ""
        var nameButtonIcon: String = ""
        var typeButtonIcon: String = ""
        var toggleToDateSortOption: SortOption
        var toggleToNameSortOption: SortOption
        var toggleToTypeSortOption: SortOption
        
        var comparator: (Document, Document) -> Bool
        
        private static let dateSorterAscending = { (doc1: Document, doc2: Document) -> Bool in
            guard let date1 = doc1.modified, let date2 = doc2.modified else {
                return true
            }
            return date1 < date2
        }
        
        private static let dateSorterDescending = { (doc1: Document, doc2: Document) -> Bool in
            guard let date1 = doc1.modified, let date2 = doc2.modified else {
                return false
            }
            return date1 > date2
        }
        
        private static let nameSorterAscending = { (doc1: Document, doc2: Document) -> Bool in
            return (doc1.name.caseInsensitiveCompare(doc2.name) == .orderedAscending) == true
        }
        
        private static let nameSorterDescending = { (doc1: Document, doc2: Document) -> Bool in
            return (doc1.name.caseInsensitiveCompare(doc2.name) == .orderedAscending) == false
        }
        
        private static let typeSorterAscending = { (doc1: Document, doc2: Document) -> Bool in
            return (fileExtensionForContentType(doc1.type).caseInsensitiveCompare(fileExtensionForContentType(doc2.type)) == .orderedAscending) == true
        }
        
        private static let typeSorterDescending = { (doc1: Document, doc2: Document) -> Bool in
            return (fileExtensionForContentType(doc1.type).caseInsensitiveCompare(fileExtensionForContentType(doc2.type)) == .orderedAscending) == false
        }
        
        static let dateDescendingSortConfigs = SortConfigs(dateButtonIcon: "arrow.down",
                                                           toggleToDateSortOption: .date(ascending: true),
                                                           toggleToNameSortOption: .name(ascending: false),
                                                           toggleToTypeSortOption: .type(ascending: false),
                                                           comparator: dateSorterDescending)
        
        static let dateAscendingSortConfigs = SortConfigs(dateButtonIcon: "arrow.up",
                                                          toggleToDateSortOption: .date(ascending: false),
                                                          toggleToNameSortOption: .name(ascending: false),
                                                          toggleToTypeSortOption: .type(ascending: false),
                                                          comparator: dateSorterAscending)
        
        static let nameDescendingSortConfigs = SortConfigs(nameButtonIcon: "arrow.down",
                                                           toggleToDateSortOption: .date(ascending: false),
                                                           toggleToNameSortOption: .name(ascending: true),
                                                           toggleToTypeSortOption: .type(ascending: false),
                                                           comparator: nameSorterDescending)
        
        static let nameAscendingSortConfigs = SortConfigs(nameButtonIcon: "arrow.up",
                                                          toggleToDateSortOption: .date(ascending: false),
                                                          toggleToNameSortOption: .name(ascending: false),
                                                          toggleToTypeSortOption: .type(ascending: false),
                                                          comparator: nameSorterAscending)
        
        static let typeDescendingSortConfigs = SortConfigs(typeButtonIcon: "arrow.down",
                                                           toggleToDateSortOption: .date(ascending: false),
                                                           toggleToNameSortOption: .name(ascending: false),
                                                           toggleToTypeSortOption: .type(ascending: true),
                                                           comparator: typeSorterDescending)
        
        static let typeAscendingSortConfigs = SortConfigs(typeButtonIcon: "arrow.up",
                                                          toggleToDateSortOption: .date(ascending: false),
                                                          toggleToNameSortOption: .name(ascending: false),
                                                          toggleToTypeSortOption: .type(ascending: false),
                                                          comparator: typeSorterAscending)
    }
}
