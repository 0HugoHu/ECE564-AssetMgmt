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

//var allSearchFiltersDict: [String: (fieldId: String, fieldType: String)] =
//    ["TransmissionReference": (fieldId: "http://ns.adobe.com/photoshop/1.0/ TransmissionReference", fieldType: "textarea"),
//     "Source": (fieldId: "http://ns.adobe.com/photoshop/1.0/ Source", fieldType: "string"),
//     "SubjectCode": (fieldId: "http://iptc.org/std/Iptc4xmpCore/1.0/xmlns/ SubjectCode", fieldType: "string"), 
//     "Description": (fieldId: "http://ns.adobe.com/xap/1.0/ Description", fieldType: "textarea"),
//     "CreatorContactInfo/Iptc4xmpCore:CiAdrCity": (fieldId: "http://iptc.org/std/Iptc4xmpCore/1.0/xmlns/ CreatorContactInfo/Iptc4xmpCore:CiAdrCity", fieldType: "string"),
//     "date": (fieldId: "http://purl.org/dc/elements/1.1/ date", fieldType: "list_date"),
//     "subject": (fieldId: "http://purl.org/dc/elements/1.1/ subject", fieldType: "list_string"),
//     "publisher": (fieldId: "http://purl.org/dc/elements/1.1/ publisher", fieldType: "list_string"),
//     "creator": (fieldId: "http://purl.org/dc/elements/1.1/ creator", fieldType: "list_string"),
//     "description": (fieldId: "http://purl.org/dc/elements/1.1/ description", fieldType: "textarea"),
//     "CreatorContactInfo/Iptc4xmpCore:CiAdrPcode": (fieldId: "http://iptc.org/std/Iptc4xmpCore/1.0/xmlns/ CreatorContactInfo/Iptc4xmpCore:CiAdrPcode", fieldType: "string"),
//     "title": (fieldId: "http://purl.org/dc/elements/1.1/ title", fieldType: "string"), 
//     "CreatorContactInfo/Iptc4xmpCore:CiEmailWork": (fieldId: "http://iptc.org/std/Iptc4xmpCore/1.0/xmlns/ CreatorContactInfo/Iptc4xmpCore:CiEmailWork", fieldType: "string"),
//     "coverage": (fieldId: "http://purl.org/dc/elements/1.1/ coverage", fieldType: "textarea"),
//     "Headline": (fieldId: "http://ns.adobe.com/photoshop/1.0/ Headline", fieldType: "textarea"),
//     "format": (fieldId: "http://purl.org/dc/elements/1.1/ format", fieldType: "string"), 
//     "Instructions": (fieldId: "http://ns.adobe.com/photoshop/1.0/ Instructions", fieldType: "textarea"), "CreatorContactInfo/Iptc4xmpCore:CiUrlWork": (fieldId: "http://iptc.org/std/Iptc4xmpCore/1.0/xmlns/ CreatorContactInfo/Iptc4xmpCore:CiUrlWork", fieldType: "string"),
//     "CreatorContactInfo/Iptc4xmpCore:CiAdrCtry": (fieldId: "http://iptc.org/std/Iptc4xmpCore/1.0/xmlns/ CreatorContactInfo/Iptc4xmpCore:CiAdrCtry", fieldType: "string"),
//     "CreatorContactInfo/Iptc4xmpCore:CiAdrExtadr": (fieldId: "http://iptc.org/std/Iptc4xmpCore/1.0/xmlns/ CreatorContactInfo/Iptc4xmpCore:CiAdrExtadr", fieldType: "string"),
//     "AuthorsPosition": (fieldId: "http://ns.adobe.com/photoshop/1.0/ AuthorsPosition", fieldType: "string"),
//     "CreatorContactInfo/Iptc4xmpCore:CiTelWork": (fieldId: "http://iptc.org/std/Iptc4xmpCore/1.0/xmlns/ CreatorContactInfo/Iptc4xmpCore:CiTelWork", fieldType: "string"),
//     "UsageTerms": (fieldId: "http://ns.adobe.com/xap/1.0/rights/ UsageTerms", fieldType: "textarea"), 
//     "source": (fieldId: "http://purl.org/dc/elements/1.1/ source", fieldType: "string"),
//     "identifier": (fieldId: "http://purl.org/dc/elements/1.1/ identifier", fieldType: "string"), 
//     "contributor": (fieldId: "http://purl.org/dc/elements/1.1/ contributor", fieldType: "list_string"),
//     "CaptionWriter": (fieldId: "http://ns.adobe.com/photoshop/1.0/ CaptionWriter", fieldType: "string"),
//     "record_id": (fieldId: "database record_id", fieldType: "string"), 
//     "directory": (fieldId: "database directory", fieldType: "string"),
//     "rights": (fieldId: "http://purl.org/dc/elements/1.1/ rights", fieldType: "textarea"),
//     "Credit": (fieldId: "http://ns.adobe.com/photoshop/1.0/ Credit", fieldType: "textarea"),
//     "file_name": (fieldId: "database file_name", fieldType: "string"),
//     "CreatorContactInfo/Iptc4xmpCore:CiAdrRegion": (fieldId: "http://iptc.org/std/Iptc4xmpCore/1.0/xmlns/ CreatorContactInfo/Iptc4xmpCore:CiAdrRegion", fieldType: "string")
//    ]
