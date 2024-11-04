//
//  TaskVC.swift
//  ToDoList
//
//  Created by Murat Çimen on 3.11.2024.
//

import UIKit
import SnapKit

class TaskVC: UIViewController {
    
    let backButton = UIButton()
    let titleLabel = UILabel()
    let plusButton = UIButton()
    let taskImageView = UIImageView()
    let taskEmptyLabel = UILabel()
    lazy var overlayImageView = UIImageView()

    var taskTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupUI()
        
        if let taskTitle = taskTitle {
            titleLabel.text = taskTitle
        }

        showOverlayIfNeeded()
    }

    func setupUI() {
        view.backgroundColor = UIColor(hex: "F9F9F9")
        
        backButton.setImage(UIImage(named: "back2"), for: .normal)
        backButton.tintColor = UIColor(hex: "#484848")
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(-8)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(50)
        }
        
        titleLabel.textColor = UIColor(hex: "#484848")
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        titleLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview()
        }
        
        plusButton.setImage(UIImage(named: "plus"), for: .normal)
        plusButton.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        
        view.addSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(-8)
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(50)
        }
        
        taskImageView.image = UIImage(named: "note")
        taskImageView.contentMode = .scaleAspectFit
        taskImageView.alpha = 0.4
        view.addSubview(taskImageView)

        taskImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).multipliedBy(0.4)
            make.centerX.equalToSuperview()
            make.width.equalTo(117)
            make.height.equalTo(117)
        }

        taskEmptyLabel.text = "There is no to-do list created yet."
        taskEmptyLabel.textAlignment = .center
        taskEmptyLabel.textColor = UIColor(hex: "#484848")
        taskEmptyLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        taskEmptyLabel.alpha = 0.5
        view.addSubview(taskEmptyLabel)

        taskEmptyLabel.snp.makeConstraints { make in
            make.top.equalTo(taskImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }
    
    func showOverlayIfNeeded() {
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        
        if isFirstLaunch {
            
            overlayImageView.image = UIImage(named: "tip1")
            overlayImageView.contentMode = .scaleAspectFill
//            overlayImageView.alpha = 0.7
            overlayImageView.isUserInteractionEnabled = true
            overlayImageView.frame = view.bounds
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOverlay))
            overlayImageView.addGestureRecognizer(tapGesture)
            
            view.addSubview(overlayImageView)
            
           
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            UserDefaults.standard.synchronize()
        }
    }
    
    @objc private func didTapOverlay() {
        overlayImageView.removeFromSuperview()
    }

    @objc private func didTapBackButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func didTapPlusButton() {
        
    }

    func configureNavigationBar() {
        navigationItem.title = ""
        navigationItem.hidesBackButton = true
    }
}
