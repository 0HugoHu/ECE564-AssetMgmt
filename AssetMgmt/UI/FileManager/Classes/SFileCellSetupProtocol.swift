//
//  SFileCellSetupProtocol.swift
//  SwiftyFileBrowser
//
//  Created by Hansen on 2021/12/6.
//

import Foundation

public protocol SFileCellSetupProtocol: AnyObject {
    static func identifierOfCell() -> String
    func setupCell(indexPath: IndexPath?, file: SFile)
    func update(fileState: SFileState)
}
