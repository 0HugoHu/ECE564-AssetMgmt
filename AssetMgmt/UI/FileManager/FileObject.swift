//
//  FileObject.swift
//  SwiftyFileBrowser_Example
//
//  Created by walker on 2021/11/24.
//  Copyright © 2021 ghostlordstar. All rights reserved.
//

import Foundation
import UIKit

class FileObject: SFile {

    convenience init(id: String, type: SFileType = .folder, name: String?, detail: String?) {
        self.init()
        self.identifier = id
        self.fileName = name
        self.detailText = detail
        self.fileType = type
    }
    
    var identifier: String = ""
    
    var filePath: String?
    
    var fileName: String?
    
    var detailText: String?
    
    var fileType: SFileType = .unknow
    
    var state: SFileState = .downloading(progress: 0.4)
    
    var thumbnail: UIImage?
    
    var appIcon: UIImage?
}

