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
        
        view.backgroundColor = UIColor(hex: "F9F9F9")
        setupUI()
    }
    
    func setupUI() {
        let settingTitleLabel = UILabel()
        settingTitleLabel.text = "Settings"
        settingTitleLabel.textAlignment = .center
        settingTitleLabel.textColor = UIColor(hex: "484848")
        settingTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        view.addSubview(settingTitleLabel)
        
        settingTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).multipliedBy(0.1)
            make.centerX.equalToSuperview()
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
            titleColor: UIColor(hex: "#4C4C4C"),
            backgroundColor: UIColor(hex: "#F9F9F9"),
            font: UIFont.systemFont(ofSize: 17),
            dynamicImageName: "Style4",
            urlString: "https://www.example.com/rate"
        )
        
        buttonVC.configureButton(
            in: stackView,
            title: "Privacy Policy",
            titleColor: UIColor(hex: "#4C4C4C"),
            backgroundColor: UIColor(hex: "#F9F9F9"),
            font: UIFont.systemFont(ofSize: 17),
            dynamicImageName: "ShieldCheck",
            urlString: "https://sites.google.com/view/neura-note/ana-sayfa"
        )
        
        
        buttonVC.configureButton(
            in: stackView,
            title: "Terms of Us",
            titleColor: UIColor(hex: "#4C4C4C"),
            backgroundColor: UIColor(hex: "#F9F9F9"),
            font: UIFont.systemFont(ofSize: 17),
            dynamicImageName: "DocumentText",
            urlString: "https://sites.google.com/view/neura-note/terms-of-use"
        )
    }
}
