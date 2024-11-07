//
//  Buttons.swift
//  ToDoList
//
//  Created by Murat Çimen on 16.10.2024.
//


import UIKit
import SnapKit

class CustomButtonVC: UIViewController {

    func configureButton(in parentStackView: UIStackView, title: String, titleColor: UIColor, backgroundColor: UIColor, font: UIFont, dynamicImageName: String, action: Selector) -> UIButton {
        
        let customButton: UIButton = {
            let button = UIButton(type: .system)
            button.layer.cornerRadius = 10
            button.backgroundColor = backgroundColor
            button.setTitleColor(titleColor, for: .normal)
            button.titleLabel?.font = font
            button.contentHorizontalAlignment = .left
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)  
            return button
        }()
        
        customButton.setTitle(title, for: .normal)
        
       
        if let dynamicImage = UIImage(systemName: dynamicImageName) {
            customButton.setImage(dynamicImage, for: .normal)
            customButton.tintColor = UIColor(hex: "#4a4949")
            customButton.imageView?.contentMode = .scaleAspectFit
        }
        
      
        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronImageView.tintColor = UIColor(hex: "#4a4949")
        customButton.addSubview(chevronImageView)
        
        
        chevronImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(15)
        }
        
        customButton.addTarget(self, action: action, for: .touchUpInside)
        
        parentStackView.addArrangedSubview(customButton)
        
        customButton.snp.makeConstraints { make in
            make.height.equalTo(51)
        }
        
        return customButton
    }
}

