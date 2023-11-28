//
//  WCLShineButtonWrapper.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/22/23.
//

import SwiftUI

enum OperationStatus : String, CaseIterable  {
    case success = "success"
    case error = "error"
    case warning = "warning"
}

struct ShineButtonWrapper: UIViewRepresentable {
    var x: Int
    var y: Int
    var r: Int
    var type: OperationStatus
    var action: () -> Void
    
    class Coordinator: NSObject {
        var action: () -> Void
        
        init(action: @escaping () -> Void) {
            self.action = action
        }
        
        @objc func buttonValueChanged() {
            action()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(action: action)
    }
    
    func makeUIView(context: Context) -> WCLShineButton {
        logger.error("\(x) \(y)")
        let button = WCLShineButton(frame: CGRect(x: x, y: y, width: r, height: r), params: WCLShineParams())
        switch (type) {
        case .success:
            button.image = WCLShineImage.custom(UIImage(named: "color-success")!)
            button.params.bigShineColor = UIColor(rgb: (165, 214, 167))
            button.params.smallShineColor = UIColor(rgb: (102, 187, 106))
            button.fillColor = UIColor(rgb: (76, 175, 80))
            button.color = UIColor(rgb: (170, 170, 170))
        case .error:
            button.image = WCLShineImage.custom(UIImage(named: "color-error")!)
            button.params.bigShineColor = UIColor(rgb: (239, 154, 154))
            button.params.smallShineColor = UIColor(rgb: (239, 83, 80))
            button.fillColor = UIColor(rgb: (244, 67, 54))
            button.color = UIColor(rgb: (170, 170, 170))
        case .warning:
            button.image = WCLShineImage.custom(UIImage(named: "color-notice")!)
            button.params.bigShineColor = UIColor(rgb: (255, 224, 130))
            button.params.smallShineColor = UIColor(rgb: (255, 202, 40))
            button.fillColor = UIColor(rgb: (255, 193, 7))
            button.color = UIColor(rgb: (170, 170, 170))
        }
        button.addTarget(context.coordinator, action: #selector(Coordinator.buttonValueChanged), for: .valueChanged)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            button.setClicked(true)
        }
        
        return button
    }
    
    func updateUIView(_ uiView: WCLShineButton, context: Context) {
    }
}


