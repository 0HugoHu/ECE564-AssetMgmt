//
//  SearchFilters.swift
//  AssetMgmt
//
//  Created by Minghui ZHU on 11/12/23.

import Foundation

var sampleSearchFiltersDict: [String: (fieldId: String, fieldType:SearchFilter.FieldTypes)] = [
    "file_name": (fieldId: "database file_name", fieldType: .Other),
    "directory": (fieldId: "database directory", fieldType: .Other),
    "date": (fieldId: "http://purl.org/dc/elements/1.1/ date", fieldType: .Date),
]
