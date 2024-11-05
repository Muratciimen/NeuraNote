//
//  CreateTaskView.swift
//  ToDoList
//
//  Created by Murat Çimen on 4.11.2024.
//

import UIKit
import SnapKit

class CreateTaskView: UIView {
    
    let createTaskTitleLabel = UILabel()
    let dueDateLabel = UILabel()
    let dueDateIcon = UIImageView()
    let dueDateButton = UIButton()
    let descriptionLabel = UILabel()
    let descriptionIcon = UIImageView()
    let descriptionTextView = UITextView()
    var saveButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 16
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.clipsToBounds = true
        
        createTaskTitleLabel.text = "Create Task"
        createTaskTitleLabel.textColor = UIColor(hex: "4C4C4C")
        createTaskTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        addSubview(createTaskTitleLabel)
        
        createTaskTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalTo(28)
        }
        
        dueDateIcon.image = UIImage(named: "Calendar")
        addSubview(dueDateIcon)
        
        dueDateIcon.snp.makeConstraints { make in
            make.top.equalTo(createTaskTitleLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(28)
            make.width.height.equalTo(20)
        }
        
        dueDateLabel.text = "Due Date:"
        dueDateLabel.textColor = UIColor(hex: "4C4C4C")
        dueDateLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        addSubview(dueDateLabel)
        
        dueDateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dueDateIcon)
            make.left.equalTo(dueDateIcon.snp.right).offset(8)
        }
        
        let attributedTitle = NSAttributedString(
            string: "   Select Date",
            attributes: [
                .font: UIFont.systemFont(ofSize: 16, weight: .regular),
                .foregroundColor: UIColor(hex: "797979")
            ]
        )

        dueDateButton.setAttributedTitle(attributedTitle, for: .normal)
        dueDateButton.layer.cornerRadius = 12
        dueDateButton.layer.borderColor = UIColor(hex: "DADADA").cgColor
        dueDateButton.layer.borderWidth = 0.5
        dueDateButton.backgroundColor = UIColor(hex: "F6F6F6")
        dueDateButton.contentHorizontalAlignment = .left
        dueDateButton.addTarget(self, action: #selector(didTapDueDateButton), for: .touchUpInside)
        addSubview(dueDateButton)

        dueDateButton.snp.makeConstraints { make in
            make.top.equalTo(dueDateLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(22)
            make.height.equalTo(50)
        }
        
        let iconImageView = UIImageView(image: UIImage(named: "right"))
        iconImageView.contentMode = .scaleAspectFit

        dueDateButton.addSubview(iconImageView)

        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
            make.height.width.equalTo(24)
        }
       
        descriptionIcon.image = UIImage(named: "PenNewSquare")
        addSubview(descriptionIcon)
        
        descriptionIcon.snp.makeConstraints { make in
            make.top.equalTo(dueDateButton.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(28)
            make.width.height.equalTo(20)
        }
        
        descriptionLabel.text = "Description:"
        descriptionLabel.textColor = UIColor(hex: "4C4C4C")
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(descriptionIcon)
            make.left.equalTo(descriptionIcon.snp.right).offset(8)
        }
        
        descriptionTextView.backgroundColor = UIColor(hex: "F6F6F6")
        descriptionTextView.layer.borderColor = UIColor(hex: "D4D9DF").cgColor
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.cornerRadius = 12
        descriptionTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionTextView.textColor = UIColor(hex: "797979")
        addSubview(descriptionTextView)
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(22)
            make.height.equalTo(100)
        }
        
        saveButton = UIButton.createCustomButton(of: .save, target: self, action: #selector(saveButtonTapped))
        addSubview(saveButton)
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(24)
            make.left.equalTo(24)
            make.right.equalTo(-24)
            make.height.equalTo(56)
        }
    }
    
    @objc private func didTapDueDateButton() {
        let datePickerVC = DatePickerViewController()
        datePickerVC.modalPresentationStyle = .pageSheet
        datePickerVC.onDateSelected = { [weak self] selectedDate in
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            let formattedDate = formatter.string(from: selectedDate)
            self?.dueDateButton.setAttributedTitle(
                NSAttributedString(
                    string: "       \(formattedDate)",
                    attributes: [
                        .font: UIFont.systemFont(ofSize: 16, weight: .regular),
                        .foregroundColor: UIColor(hex: "797979")
                    ]
                ),
                for: .normal
            )
        }

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first(where: { $0.isKeyWindow }),
           let topController = window.rootViewController {
            topController.present(datePickerVC, animated: true, completion: nil)
        }
    }

    
    @objc private func saveButtonTapped() {
       
    }
}
