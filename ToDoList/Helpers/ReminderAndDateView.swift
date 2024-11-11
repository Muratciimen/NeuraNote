//
//  ReminderAndDateView.swift
//  ToDoList
//
//  Created by Murat Çimen on 8.11.2024.
//

import Foundation
import UIKit
import SnapKit

class ReminderAndDateView: UIView {
    
    let dateView = UIView()
    let dueDateIcon = UIImageView()
    let dueDateLabel = UILabel()
    let dateLabel = UILabel()
    let reminderView = UIView()
    let reminderIcon = UIImageView()
    let reminderLabel = UILabel()
    let reminderSecondLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        dateView.backgroundColor = .red
//        dateView.backgroundColor = UIColor(hex: "F6F6F6")
        dateView.layer.borderColor = UIColor(hex: "DADADA").cgColor
        dateView.layer.cornerRadius = 12
        dateView.layer.borderWidth = 0.5
        self.addSubview(dateView)
        
        dateView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(50)
        }
               
        dueDateIcon.image = UIImage(named: "Calendar")
        dateView.addSubview(dueDateIcon)
        
        dueDateIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(20)
        }
        
        dueDateLabel.text = "Due Date:"
        dueDateLabel.textColor = UIColor(hex: "4C4C4C")
        dueDateLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        dateView.addSubview(dueDateLabel)
        
        dueDateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(dueDateIcon.snp.right).offset(8)
        }
        
        dateLabel.text = ""
        dateLabel.textColor = UIColor(hex: "9C9C9C")
        dateLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        dateView.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(dueDateLabel.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
        }
        
        reminderView.backgroundColor = UIColor(hex: "F6F6F6")
        reminderView.layer.borderColor = UIColor(hex: "DADADA").cgColor
        reminderView.layer.cornerRadius = 12
        reminderView.layer.borderWidth = 0.5
        self.addSubview(reminderView)
        
        reminderView.snp.makeConstraints { make in
            make.top.equalTo(dateView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(50)
        }
        
        reminderIcon.image = UIImage(named: "Alarm")
        reminderView.addSubview(reminderIcon)
        
        reminderIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(20)
        }
        
        reminderLabel.text = "Reminder:"
        reminderLabel.textColor = UIColor(hex: "4C4C4C")
        reminderLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        reminderView.addSubview(reminderLabel)
        
        reminderLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(dueDateIcon.snp.right).offset(8)
        }
        
        reminderSecondLabel.text = ""
        reminderSecondLabel.textColor = UIColor(hex: "9C9C9C")
        reminderSecondLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        reminderView.addSubview(reminderSecondLabel)
        
        reminderSecondLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(dueDateLabel.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
        }
    }
}



