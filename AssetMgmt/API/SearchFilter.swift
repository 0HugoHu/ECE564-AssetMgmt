//
//  SearchFilter.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/9/23.
//

import Foundation



class SearchFilter {
    // Function to form the example format with generics
    static func createSearchCriteria<T>(conjunction: Conjunction, fieldId: String, condition: T, value: String) -> String where T: RawRepresentable, T.RawValue == String {
        let criteria: [String: Any] = [
            "fieldId": fieldId,
            "condition": condition.rawValue,
            "value": value
        ]
        
        let searchCriteria: [String: Any] = [
            "conjunction": conjunction.rawValue,
            "criteria": [criteria]
        ]
        
        // Convert to JSON data for sending
        if let jsonData = try? JSONSerialization.data(withJSONObject: searchCriteria, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        } else {
            return ""
        }
    }
    
    
    // Conjunction
    enum Conjunction : String {
        case and = "AND"
        case or = "OR"
        case not = "NOT"
    }
    
    
    // Container Fields
    enum ContainerField : String, CaseIterable {
        case cont = "cont"
        case notCont = "not_cont"
        case not = "not"
        case isNull = "null"
        case contPart = "cont_part"
        case notContPart = "not_cont_part"
    }
    
    
    // Integer Fields
    enum IntegerField : String, CaseIterable {
        case not = "not"
        case isNull = "null"
        case equals = "eq"
        case notEquals = "ne"
        case lessThan = "lt"
        case lessThanOrEqual = "le"
        case greaterThan = "gt"
        case greaterThanOrEqual = "ge"
        case anyValue = "anyval"
        case notChanged = "notchanged"
    }
    
    
    // Hierarchy Fields
    enum HierarchyField : String, CaseIterable {
        case not = "not"
        case isNull = "null"
        case equals = "eq"
        case notEquals = "ne"
        case anyValue = "anyval"
        case notChanged = "notchanged"
    }
    
    
    // Date Fields
    enum DateField : String, CaseIterable {
        case not = "not"
        case isNull = "null"
        case equals = "eq"
        case notEquals = "ne"
        case lessThan = "lt"
        case lessThanOrEqual = "le"
        case greaterThan = "gt"
        case greaterThanOrEqual = "ge"
        case between = "between"
        case anyValue = "anyval"
        case notChanged = "notchanged"
    }
    
    
    // Other Fields
    enum OtherField : String, CaseIterable {
        case not = "not"
        case isNull = "null"
        case equals = "eq"
        case notEquals = "ne"
        case beginsWith = "beg"
        case notBeginsWith = "not_beg"
        case endsWith = "end"
        case notEndsWith = "not_end"
        case contains = "cont"
        case notContains = "not_cont"
        case all = "all"
        case any = "any"
        case phrase = "phrase"
        case without = "wo"
        case anyValue = "anyval"
        case notChanged = "notchanged"
    }
    
    enum FieldTypes: String, CaseIterable {
        case Container = "Container"
        case Integer = "Integer"
        case Hierarchy = "Hierarchy"
        case Date = "Date"
        case Other = "Other"
        
        func getAllCases() -> [String] {
            switch self {
            case .Container:
                return ContainerField.allCases.map { $0.rawValue }
            case .Integer:
                return IntegerField.allCases.map { $0.rawValue }
            case .Hierarchy:
                return HierarchyField.allCases.map { $0.rawValue }
            case .Date:
                return DateField.allCases.map { $0.rawValue }
            case .Other:
                return OtherField.allCases.map { $0.rawValue }
            }
        }
    }
}
