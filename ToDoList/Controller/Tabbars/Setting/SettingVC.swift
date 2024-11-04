//
//  SettingVC.swift
//  ToDoList
//
//  Created by Murat Çimen on 16.10.2024.
//

import UIKit
import SnapKit

class SettingVC: UIViewController {
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 16
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: "#EEEEEE")
        setupUI()
    }
    
    func setupUI() {
        let settingTitleLabel = UILabel()
        settingTitleLabel.text = "Setting"
        settingTitleLabel.textAlignment = .left
        settingTitleLabel.textColor = UIColor(hex: "#4a4949")
        settingTitleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        view.addSubview(settingTitleLabel)
        
        settingTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).multipliedBy(0.1)
            make.left.equalTo(16)
        }
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(settingTitleLabel.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(16)
        }
        
        configureButtons()
    }
    
    func configureButtons() {
        let buttonVC = CustomButtonVC()
        
      
        buttonVC.configureButton(
            in: stackView,
            title: "Rate Us",
            titleColor: UIColor(hex: "#4a4949"),
            backgroundColor: UIColor(hex: "#DBDBDB"),
            font: UIFont.systemFont(ofSize: 17),
            dynamicImageName: "star",
            action: #selector(rateUsButtonTapped)
        )
        
      
        buttonVC.configureButton(
            in: stackView,
            title: "Share the App",
            titleColor: UIColor(hex: "#4a4949"),
            backgroundColor: UIColor(hex: "#DBDBDB"),
            font: UIFont.systemFont(ofSize: 17),
            dynamicImageName: "square.and.arrow.up",
            action: #selector(shareAppButtonTapped)
        )
        
        
        buttonVC.configureButton(
            in: stackView,
            title: "Give Feedback",
            titleColor: UIColor(hex: "#4a4949"),
            backgroundColor: UIColor(hex: "#DBDBDB"),
            font: UIFont.systemFont(ofSize: 17),
            dynamicImageName: "exclamationmark.bubble",
            action: #selector(giveFeedbackButtonTapped)
        )
        
        
        buttonVC.configureButton(
            in: stackView,
            title: "Terms of Us",
            titleColor: UIColor(hex: "#4a4949"),
            backgroundColor: UIColor(hex: "#DBDBDB"),
            font: UIFont.systemFont(ofSize: 17),
            dynamicImageName: "doc.text",
            action: #selector(termsOfUseButtonTapped)
        )
        
        
        buttonVC.configureButton(
            in: stackView,
            title: "Privacy Policy",
            titleColor: UIColor(hex: "#4a4949"),
            backgroundColor: UIColor(hex: "#DBDBDB"),
            font: UIFont.systemFont(ofSize: 17),
            dynamicImageName: "eye",
            action: #selector(privacyPolicyButtonTapped)
        )
    }
    
    
    @objc func rateUsButtonTapped() {
        print("Rate Us butonuna tıklandı")
      
    }
    
    @objc func shareAppButtonTapped() {
        print("Share the App butonuna tıklandı")
        
    }
    
    @objc func giveFeedbackButtonTapped() {
        print("Give Feedback butonuna tıklandı")
       
    }
    
    @objc func termsOfUseButtonTapped() {
        print("Terms of Use butonuna tıklandı")
       
    }
    
    @objc func privacyPolicyButtonTapped() {
        print("Privacy Policy butonuna tıklandı")
       
    }
}
