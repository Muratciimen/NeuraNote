//
//  TaskDetail.swift
//  ToDoList
//
//  Created by Murat Çimen on 7.11.2024.

import UIKit
import SnapKit

class TaskDetail: UIViewController {
    
    var label = UILabel()
    var taskTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureNavigationBar()
        
     
        if let title = taskTitle {
            label.text = title
        }
    }
    
    func setupUI() {
        
        view.backgroundColor = UIColor(hex: "F9F9F9")
        
        let headerView = CustomHeaderView(headerType: .taskDetail)
        view.addSubview(headerView)
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).multipliedBy(0.1)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.textColor = UIColor(hex: "#4a4949")
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(24)
            make.left.equalTo(24)
            make.right.equalTo(-24)
        }
    }
    
    func configureNavigationBar() {
        navigationItem.title = ""
        navigationItem.hidesBackButton = true
    }
}
