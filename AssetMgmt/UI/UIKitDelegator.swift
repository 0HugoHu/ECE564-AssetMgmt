//
//  UIKitDelegator.swift
//  AssetMgmt
//
//  Created by Hugooooo on 10/29/23.
//

import SwiftUI
import UIKit

struct FileManagerRootViewDelegator: UIViewControllerRepresentable {
    typealias UIViewControllerType = PathListViewController

    func makeUIViewController(context: Context) -> PathListViewController {
        // Instantiate and configure your UIKit view controller here
        return PathListViewController(style: .userPreferred, path: .root)
    }

    func updateUIViewController(_ uiViewController: PathListViewController, context: Context) {
        // Update the UIKit view controller when necessary
        // You can pass data from the SwiftUI view to the UIKit view controller here
    }
}
