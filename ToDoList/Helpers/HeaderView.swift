//
//  HeaderView.swift
//  ToDoList
//
//  Created by Murat Çimen on 1.11.2024.
//

import Foundation
import UIKit
import SnapKit

enum HeaderType {
    case toDoList
    case calender
    case settings
    case taskDetail
    
    var title: String {
        switch self {
        case .toDoList:
            return "To Do List"
        case .calender:
            return "Calender"
        case .settings:
            return "Settings"
        case .taskDetail:
            return "Task Detail"
        }
    }
}

class CustomHeaderView: UIView {
    
    private let titleLabel = UILabel()
    private let backButton = UIButton(type: .system)
    
    init(headerType: HeaderType) {
        super.init(frame: .zero)
        setupUI(headerType: headerType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(headerType: HeaderType) {
       
        backButton.setImage(UIImage(named: "back2"), for: .normal)
        backButton.tintColor = UIColor(hex: "#484848")
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(50)
        }
        
       
        titleLabel.text = headerType.title
        titleLabel.textColor = UIColor(hex: "#484848")
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        titleLabel.textAlignment = .center
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview() 
        }
    }

    
    @objc private func didTapBackButton() {
        if let viewController = findViewController() {
            viewController.navigationController?.popViewController(animated: true)
        }
    }
    
    private func findViewController() -> UIViewController? {
        var nextResponder: UIResponder? = self
        while let responder = nextResponder {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            nextResponder = responder.next
        }
        return nil
    }
}
