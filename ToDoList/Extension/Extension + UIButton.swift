//
//  Extension + UIButton.swift
//  ToDoList
//
//  Created by Murat Çimen on 3.11.2024.
//

//import UIKit
//import SnapKit
//
//extension UIButton {
//    static func createCustomButton(of type: OrangeButtons, target: Any, action: Selector) -> UIButton {
//        let button = UIButton(type: .system)
//        button.setTitle(type.title, for: .normal)
//        button.backgroundColor = type.backgroundColor
//        button.setTitleColor(type.titleColor, for: .normal)
//        button.titleLabel?.font = type.font
//        button.layer.cornerRadius = type.cornerRadius
//        button.addTarget(target, action: action, for: .touchUpInside)
//
//        
//        if let icon = type.icon {
//            button.setImage(icon, for: .normal)
//            button.imageView?.contentMode = .scaleAspectFit
//            button.tintColor = .white
//            button.semanticContentAttribute = .forceRightToLeft 
//            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
//
//            button.imageView?.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                button.imageView!.widthAnchor.constraint(equalToConstant: 20),
//                button.imageView!.heightAnchor.constraint(equalToConstant: 20)
//            ])
//        }
//
//        return button
//    }
//}

