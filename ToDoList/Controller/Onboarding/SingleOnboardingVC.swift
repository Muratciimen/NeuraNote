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
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        guard let pageData = pageData else { return }
        
        imageView.image = UIImage(named: pageData.imageName)
        titleLabel.text = pageData.title
        descriptionLabel.text = pageData.description
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
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
    }
}
