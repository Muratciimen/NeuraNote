//
//  SingleOnboardingVC.swift
//  ToDoList
//
//  Created by Murat Çimen on 19.11.2024.
//

import UIKit
import SnapKit

class SingleOnboardingVC: UIViewController {
    
    var pageData: OnboardingPage?
    var pageIndex: Int?
    var continueCallback: (() -> Void)?
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let continueButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        guard let pageData = pageData else { return }
        
        imageView.image = UIImage(named: pageData.imageName)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        titleLabel.text = pageData.title
        titleLabel.textColor = UIColor(hex: "484848")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        
        descriptionLabel.text = pageData.description
        descriptionLabel.textColor = UIColor(hex: "484848")
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        
        continueButton.setTitle("Continue", for: .normal)
        continueButton.backgroundColor = UIColor(hex: "FFAF5F")
        continueButton.layer.cornerRadius = 8
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(continueButton)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).multipliedBy(0.7)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        continueButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(56)
        }
    }
    
    @objc private func continueButtonTapped() {
        continueCallback?() 
    }
}
