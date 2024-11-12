//
//  Buttons.swift
//  ToDoList
//
//  Created by Murat Çimen on 16.10.2024.
//


import UIKit
import SnapKit

class CustomButtonVC: UIViewController {

    func configureButton(in parentStackView: UIStackView, title: String, titleColor: UIColor, backgroundColor: UIColor, font: UIFont, dynamicImageName: String, urlString: String) -> UIButton {
        
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
        
        if let dynamicImage = UIImage(named: dynamicImageName)?.withRenderingMode(.alwaysTemplate) {
            customButton.setImage(dynamicImage, for: .normal)
            customButton.imageView?.contentMode = .scaleAspectFit
            customButton.tintColor = UIColor(hex: "#FEA543")
        }
        
        let chevronImageView = UIImageView(image: UIImage(named: "right")?.withRenderingMode(.alwaysTemplate))
        chevronImageView.tintColor = UIColor(hex: "#64666D")
        customButton.addSubview(chevronImageView)
        
        chevronImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(15)
        }
        
        customButton.addAction(UIAction(handler: { _ in
            self.openURL(urlString)
        }), for: .touchUpInside)
        
        parentStackView.addArrangedSubview(customButton)
        
        customButton.snp.makeConstraints { make in
            make.height.equalTo(51)
        }
        
        return customButton
    }

    func openURL(_ urlString: String) {
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
            print("Geçersiz URL: \(urlString)")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
