//
//  SFileBaseCollectionViewCell.swift
//  SwiftyFileBrowser
//
//  Created by b612 on 2022/2/27.
//

import UIKit

open class SFileBaseCollectionViewCell: UICollectionViewCell {
    open var indexPath: IndexPath?
    open var file: SFile?
    open weak var delegate: SFileBrowserDelegate?
    open var isEditing: Bool = false
}
