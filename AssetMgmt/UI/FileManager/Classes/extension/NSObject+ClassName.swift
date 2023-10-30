//
//  NSObject+ClassName.swift
//  SwiftyFileBrowser
//
//  Created by Hansen on 2021/12/6.
//

import Foundation

public extension NSObject {
    
    class var className: String {
        let typeName = "\(type(of: Self.self))"
        let nameArray = typeName.components(separatedBy: ".")
        return nameArray.first ?? typeName
    }
    
    var className: String {
        let typeName = "\(type(of: self))"
        let nameArray = typeName.components(separatedBy: ".")
        return nameArray.first ?? typeName
    }
}
