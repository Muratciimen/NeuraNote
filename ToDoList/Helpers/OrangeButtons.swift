//
//  OrangeButtons.swift
//  ToDoList
//
//  Created by Murat Çimen on 3.11.2024.
//

import UIKit
import SnapKit

enum OrangeButtons {
    case create
    case save
    case selected
    case editTask

    var title: String {
        switch self {
        case .create: return "Create"
        case .save: return "Save"
        case .selected: return "Selected"
        case .editTask: return "Edit Task"
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .editTask:
            return UIColor(hex: "#FFAF5F")
        default:
            return UIColor(hex: "#FFE1C3")
        }
    }

    var titleColor: UIColor {
        return .white
    }

    var font: UIFont {
        return UIFont.systemFont(ofSize: 16)
    }

    var cornerRadius: CGFloat {
        return 10.0
    }

    var height: CGFloat {
        return 56.0
    }

    var icon: UIImage? {
        switch self {
        case .editTask:
            return UIImage(named: "Pen2")
        default:
            return nil
        }
    }
}

extension UIButton {
    static func createCustomButton(of type: OrangeButtons, target: Any, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(type.title, for: .normal)
        button.backgroundColor = type.backgroundColor
        button.setTitleColor(type.titleColor, for: .normal)
        button.titleLabel?.font = type.font
        button.layer.cornerRadius = type.cornerRadius
        button.addTarget(target, action: action, for: .touchUpInside)

            var configuration = UIButton.Configuration.borderless() // 1
            configuration.cornerStyle = .capsule // 2
            configuration.baseBackgroundColor = type.backgroundColor
            configuration.buttonSize = .large
            configuration.imagePadding = 16
            configuration.imagePlacement = .trailing
            configuration.title = type.title
            configuration.image = type.icon
            configuration.baseForegroundColor = UIColor(hex: "#FFFFFF")
            button.configuration = configuration


        return button
    }
}

//import UIKit
//
//enum OrangeButtons {
//    case create
//    case save
//    case selected
//    case editTask
//
//    var title: String {
//        switch self {
//        case .create: return "Create"
//        case .save: return "Save"
//        case .selected: return "Selected"
//        case .editTask: return "Edit Task"
//        }
//    }
//
//    var backgroundColor: UIColor {
//        return UIColor(hex: "#FFE1C3")
//    }
//
//    var titleColor: UIColor {
//        return .white
//    }
//
//    var font: UIFont {
//        return UIFont.systemFont(ofSize: 16)
//    }
//
//    var cornerRadius: CGFloat {
//        return 10.0
//    }
//
//    var height: CGFloat {
//        return 56.0
//    }
//
//    var icon: UIImage? {
//        switch self {
//        case .editTask:
//            return UIImage(named: "Pen2")
//        default:
//            return nil
//        }
//    }
//}
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
//
