//
//  ViewController.swift
//  SwiftyFileBrowser
//
//  Created by Hansen on 11/24/2021.
//  Copyright (c) 2021 Hansen. All rights reserved.
//

import UIKit

class PathListViewController: UIViewController {
    
    var sfbView: SwiftyFileBrowser?
    var files: [FileObject] = [FileObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let switchItem = UIBarButtonItem.init(title: "切换", style: .plain, target: self, action: #selector(p_swiftchListType))
        let refreshItem = UIBarButtonItem.init(barButtonSystemItem: .refresh, target: self, action: #selector(p_refreshList))
        let selectItem = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: #selector(p_selectAction))
        self.navigationItem.rightBarButtonItems = [switchItem, refreshItem, selectItem]
        self.sfbView = SwiftyFileBrowser.init(frame: CGRect.init(x: 0, y: SFFit.navWithStatusBarHeight, width: SFFit.width, height: SFFit.height - SFFit.navWithStatusBarHeight), type: .icons)
        self.sfbView?.delegate = self
        self.files = [
            FileObject.init(id: "111", type: .folder, name: "name111434534534534523423535436346awefasdfas", detail: "2021/09/11-asdgsfgfadsfadfadfasdfadfadfadfadf"),
            FileObject.init(id: "222", name: "name222", detail: "2021/09/13"),
            FileObject.init(id: "333", name: "name333", detail: "2021/09/14"),
            FileObject.init(id: "444", type: .unknow, name: "name444", detail: "2021/09/14"),
            FileObject.init(id: "555", name: "name555", detail: "2021/09/15"),
            FileObject.init(id: "666", name: "name666", detail: "2021/09/16"),
            FileObject.init(id: "777", name: "name666", detail: "2021/09/16"),
            FileObject.init(id: "888", name: "name666", detail: "2021/09/16"),
            FileObject.init(id: "999", name: "name666", detail: "2021/09/16"),
            FileObject.init(id: "000", name: "name666", detail: "2021/09/16"),
            FileObject.init(id: "1000", name: "name666", detail: "2021/09/16"),
            FileObject.init(id: "1001", name: "name666", detail: "2021/09/16"),
            FileObject.init(id: "1002", name: "name666", detail: "2021/09/16"),
            FileObject.init(id: "1003", name: "name666", detail: "2021/09/16"),
            FileObject.init(id: "1004", name: "name666", detail: "2021/09/16"),
        ]
        
        //        // Long press Actions
        //        let copyEle = UIAction.init(title: "Copy", image: nil, identifier: UIAction.Identifier.init("LongPress-Copy"), discoverabilityTitle: nil, attributes: [], state: .off) { act in
        //            print("LongPress copy event!,index: \(self.sfbView?.longPressIndex)")
        //            // TODO: copy logic
        //        }
        //
        //        let moveEle = UIAction.init(title: "Move", image: nil, identifier: UIAction.Identifier.init("LongPress-Move"), discoverabilityTitle: nil, attributes: [], state: .off) { act in
        //            print("LongPress Move event!,index: \(self.sfbView?.longPressIndex)")
        //            // TODO: Move logic
        //        }
        
        //        self.sfbView?.longPressMenuElements = [copyEle, moveEle]
        //
        //        self.longPressIndexPathDidChange?(indexPath)
        //        let menuView = UIMenu.init(title: "", image: nil, identifier: UIMenu.Identifier.init(rawValue: "com.swiftFileBrowser.longpress.menuView"), options: UIMenu.Options.displayInline, children: actions)
        //        return UIContextMenuConfiguration.init(identifier: nil, previewProvider: nil) { _ in
        //            menuView
        //
        self.sfbView?.scrollDelegate = self
        self.sfbView?.reloadBrowser(files: self.files)
        self.view.addSubview(self.sfbView!)
        
        //        self.testFileType()
    }
    
    @objc func p_swiftchListType() {
        self.sfbView?.switchTo()
    }
    
    @objc func p_refreshList() {
        self.sfbView?.reloadBrowser(files: self.files)
    }
    
    @objc func p_selectAction() {
        self.sfbView?.setediting(!self.sfbView!.isEditing, animated: true)
    }
    
    //    func testFileType() {
    //        // 不相等
    //        var type1: SFileType = .folder
    //        var type2: SFileType = .html
    //        if case type1 = type2 {
    //            print("folder == html")
    //        }else {
    //            print("folder != html")
    //        }
    //        // 相等
    //        type1 = .folder
    //        type2 = .folder
    //        if case type1 = type2 {
    //            print("folder == folder")
    //        }else {
    //            print("folder != folder")
    //        }
    //        // 关联值不相等
    //        type1 = .image(format: "a")
    //        type2 = .image(format: "b")
    //        if case type1 = type2 {
    //            print("image.a == image.b")
    //        }else {
    //            print("image.a != image.b")
    //        }
    //        // 完全相等
    //        type1 = .image(format: "a")
    //        type2 = .image(format: "a")
    //        if case type1 = type2 {
    //            print("image.a == image.a")
    //        }else {
    //            print("image.a != image.a")
    //        }
    //        // 类型不相等
    //        type1 = .image(format: "a")
    //        type2 = .folder
    //        if case type1 = type2 {
    //            print("image.a == folder")
    //        }else {
    //            print("image.a != folder")
    //        }
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PathListViewController: SFileBrowserDelegate {
    func fileMultipleSelection(indexPath: IndexPath?, indexPathSet: [IndexPath]?) {
        print("multipleSelction:\(String(describing: indexPathSet))")
    }
    
    func fileDidEndLongPressAction(indexPath: IndexPath?, file: SFile) {
        print("end long press, index:\(String(describing: indexPath))")
    }
    
    func fileDownloadButtonAction(indexPath: IndexPath?, file: SFile) {
        print("\(#function)")
    }
    
    func fileLongPressAction(indexPath: IndexPath?, file: SFile) -> UIContextMenuConfiguration? {
        
        // Long press Actions
        let copyEle = UIAction.init(title: "Copy", image: nil, identifier: UIAction.Identifier.init("LongPress-Copy"), discoverabilityTitle: nil, attributes: [], state: .off) { act in
            print("LongPress copy event!,index: \(String(describing: indexPath))")
            // TODO: copy logic
        }
        
        let moveEle = UIAction.init(title: "Move", image: nil, identifier: UIAction.Identifier.init("LongPress-Move"), discoverabilityTitle: nil, attributes: [], state: .off) { act in
            print("LongPress Move event!,index: \(String(describing: indexPath))")
            // TODO: Move logic
        }
        
        let menuView = UIMenu.init(title: "", image: nil, identifier: UIMenu.Identifier.init(rawValue: "com.swiftFileBrowser.longpress.menuView"), options: UIMenu.Options.displayInline, children: [copyEle, moveEle])
        return UIContextMenuConfiguration.init(identifier: nil, previewProvider: nil) { _ in
            menuView
        }
    }
    
    func fileTouchAction(indexPath: IndexPath?, file: SFile) {
        print("\(#function)")
    }
}

extension PathListViewController: SFileBrowserScrollDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollView did scroll: \(scrollView.contentOffset)")
    }
}
