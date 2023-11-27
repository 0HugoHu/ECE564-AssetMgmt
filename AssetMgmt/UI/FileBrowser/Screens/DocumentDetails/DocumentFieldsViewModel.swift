import Foundation
import SwiftUI

class DocumentFieldsViewModel: ObservableObject {
    @Published var dcFields: Fields
    @Published var id: Int


    init(dcFields: Fields, id: Int) {
        self.dcFields = dcFields
        self.id = id
    }
    
//    func updateDC() {
//        let customJSON = dcFields.toCustomJSON(id: id)
//        updateDublinCore(customJSON: customJSON) { success in
//            if success {
//                print("Update successful")
//            } else {
//                print("Update failed")
//            }
//        }
//    }
}

extension DocumentFieldsViewModel {
    var fieldKeys: [String] {
        return ["Title", "Description", "Keyword", "Creator", "Rights",
                "Contributor", "Publisher", "Coverage", "Date",
                "Identifier", "Source", "Format"]
    }

    func value(forKey key: String) -> Any? {
        switch key {
        case "Title":
            return dcFields.title
        case "Description":
            return dcFields.description
        case "Keyword":
            return dcFields.keyword
        case "Creator":
            return dcFields.creator
        case "Rights":
            return dcFields.rights
        case "Contributor":
            return dcFields.contributor
        case "Publisher":
            return dcFields.publisher
        case "Coverage":
            return dcFields.coverage
        case "Date":
            return dcFields.date
        case "Identifier":
            return dcFields.identifier
        case "Source":
            return dcFields.source
        case "Format":
            return dcFields.format
        default:
            return nil
        }
    }
}

extension DocumentFieldsViewModel {
    func binding<T>(for key: String, default defaultValue: T) -> Binding<T> {
        switch key {
        case "Title":
            return Binding(
                get: { self.dcFields.title as? T ?? defaultValue },
                set: { self.dcFields.title = $0 as? String ?? "" }
            )
        case "Description":
            return Binding(
                get: { self.dcFields.description as? T ?? defaultValue },
                set: { self.dcFields.description = $0 as? String ?? "" }
            )
        case "Keyword":
            return Binding(
                get: { self.dcFields.keyword as? T ?? defaultValue },
                set: { self.dcFields.keyword = $0 as? [String] ?? [] }
            )
        case "Creator":
            return Binding(
                get: { self.dcFields.creator as? T ?? defaultValue },
                set: { self.dcFields.creator = $0 as? [String] ?? [] }
            )
        case "Rights":
            return Binding(
                get: { self.dcFields.rights as? T ?? defaultValue },
                set: { self.dcFields.rights = $0 as? [String] ?? [] }
            )
        case "Contributor":
            return Binding(
                get: { self.dcFields.contributor as? T ?? defaultValue },
                set: { self.dcFields.contributor = $0 as? [String] ?? [] }
            )
        case "Publisher":
            return Binding(
                get: { self.dcFields.publisher as? T ?? defaultValue },
                set: { self.dcFields.publisher = $0 as? [String] ?? [] }
            )
        case "Coverage":
            return Binding(
                get: { self.dcFields.coverage as? T ?? defaultValue },
                set: { self.dcFields.coverage = $0 as? String ?? "" }
            )
        case "Date":
            return Binding(
                get: { self.dcFields.date as? T ?? defaultValue },
                set: { self.dcFields.date = $0 as? [String] ?? [] }
            )
        case "Identifier":
            return Binding(
                get: { self.dcFields.identifier as? T ?? defaultValue },
                set: { self.dcFields.identifier = $0 as? String ?? "" }
            )
        case "Source":
            return Binding(
                get: { self.dcFields.source as? T ?? defaultValue },
                set: { self.dcFields.source = $0 as? String ?? "" }
            )
        case "Format":
            return Binding(
                get: { self.dcFields.format as? T ?? defaultValue },
                set: { self.dcFields.format = $0 as? String ?? "" }
            )
        default:
            return .constant(defaultValue)
        }
    }
}
