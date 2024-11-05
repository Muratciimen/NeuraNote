//
//  CreateTaskViewController.swift
//  ToDoList
//
//  Created by Murat Çimen on 4.11.2024.
//

import UIKit
import SnapKit

protocol CreateTaskViewControllerDelegate: AnyObject {
    func didCreateTask(title: String, dueDate: String)
}

class CreateTaskViewController: UIViewController, UITextViewDelegate  {
    
    let createTaskTitleLabel = UILabel()
    let dueDateLabel = UILabel()
    let dueDateIcon = UIImageView()
    let dueDateButton = UIButton()
    let descriptionLabel = UILabel()
    let descriptionIcon = UIImageView()
    let descriptionTextView = UITextView()
    var saveButton = UIButton()
    let datePickerContainer = UIView()
    let datePicker = UIDatePicker()
    weak var delegate: CreateTaskViewControllerDelegate?
    @objc var datePickerSelectButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupDatePickerContainer()
        configureDatePicker()
        descriptionTextView.delegate = self
        saveButton.isEnabled = false
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        
        createTaskTitleLabel.text = "Create Task"
        createTaskTitleLabel.textColor = UIColor(hex: "4C4C4C")
        createTaskTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(createTaskTitleLabel)
        
        createTaskTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalTo(28)
        }
        
        dueDateIcon.image = UIImage(named: "Calendar")
        view.addSubview(dueDateIcon)
        
        dueDateIcon.snp.makeConstraints { make in
            make.top.equalTo(createTaskTitleLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(28)
            make.width.height.equalTo(20)
        }
        
        dueDateLabel.text = "Due Date:"
        dueDateLabel.textColor = UIColor(hex: "4C4C4C")
        dueDateLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        view.addSubview(dueDateLabel)
        
        dueDateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dueDateIcon)
            make.left.equalTo(dueDateIcon.snp.right).offset(8)
        }
        
        dueDateButton.setTitle("Select Date", for: .normal)
        dueDateButton.setTitleColor(UIColor(hex: "797979"), for: .normal)
        dueDateButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        dueDateButton.layer.cornerRadius = 12
        dueDateButton.layer.borderColor = UIColor(hex: "DADADA").cgColor
        dueDateButton.layer.borderWidth = 0.5
        dueDateButton.backgroundColor = UIColor(hex: "F6F6F6")
        dueDateButton.contentHorizontalAlignment = .left
        dueDateButton.addTarget(self, action: #selector(didTapDueDateButton), for: .touchUpInside)
        dueDateButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)

        view.addSubview(dueDateButton)
        
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
        view.addSubview(descriptionIcon)
        
        descriptionIcon.snp.makeConstraints { make in
            make.top.equalTo(dueDateButton.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(28)
            make.width.height.equalTo(20)
        }
        
        descriptionLabel.text = "Description:"
        descriptionLabel.textColor = UIColor(hex: "4C4C4C")
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        view.addSubview(descriptionLabel)
        
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
        view.addSubview(descriptionTextView)
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(22)
            make.height.equalTo(100)
        }
        
        saveButton = UIButton.createCustomButton(of: .save, target: self, action: #selector(saveButtonTapped))
        view.addSubview(saveButton)
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(24)
            make.left.equalTo(24)
            make.right.equalTo(-24)
            make.height.equalTo(56)
        }
    }
    
    private func setupDatePickerContainer() {
        datePickerContainer.backgroundColor = .white
        datePickerContainer.layer.cornerRadius = 16
        datePickerContainer.layer.borderColor = UIColor.lightGray.cgColor
        datePickerContainer.isHidden = true
        view.addSubview(datePickerContainer)

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        datePickerContainer.addSubview(datePicker)

        datePicker.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(200)
        }

        datePickerSelectButton = UIButton.createCustomButton(of: .selected, target: self, action: #selector(didSelectDate))
        datePickerSelectButton.isEnabled = false
        datePickerContainer.addSubview(datePickerSelectButton)

        datePickerSelectButton.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(24)
            make.left.equalTo(24)
            make.right.equalTo(-24)
            make.height.equalTo(56)
        }
        
        datePickerContainer.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(400)
        }
    }
    
    private func configureDatePicker() {
        datePicker.minimumDate = Date()
    }

    @objc private func didTapDueDateButton() {
        datePickerContainer.isHidden = false
    }
    
    @objc private func datePickerValueChanged() {
        datePickerSelectButton.isEnabled = true
        datePickerSelectButton.backgroundColor = UIColor(hex: "FFAF5F")
        checkIfSaveButtonShouldBeEnabled()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkIfSaveButtonShouldBeEnabled()
    }
    
    private func checkIfSaveButtonShouldBeEnabled() {
        if let dueDateText = dueDateButton.titleLabel?.text, !dueDateText.contains("Select Date"),
           !descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            saveButton.isEnabled = true
            saveButton.backgroundColor = UIColor(hex: "FFAF5F")
        } else {
            saveButton.isEnabled = false
        }
    }
    
    @objc private func didSelectDate() {
        let selectedDate = datePicker.date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let formattedDate = formatter.string(from: selectedDate)
        
        dueDateButton.setAttributedTitle(
            NSAttributedString(
                string: "       \(formattedDate)",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 16, weight: .regular),
                    .foregroundColor: UIColor(hex: "797979")
                ]
            ),
            for: .normal
        )
        
        datePickerContainer.isHidden = true
    }
    
    @objc private func saveButtonTapped() {
        guard let taskDescription = descriptionTextView.text,
              !taskDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("Task description is empty.")
            return
        }

        let dueDateString = dueDateButton.titleLabel?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let dueDateText = dueDateString, !dueDateText.contains("Select Date") else {
            print("Due date not selected.")
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        guard let dueDate = formatter.date(from: dueDateText) else {
            print("Invalid due date format.")
            return
        }
        
        if let _ = CoreDataManager.shared.createItem(name: taskDescription, dueDate: dueDate, color: UIColor.systemBlue) {
            print("Task successfully saved to CoreData.")
        } else {
            print("Failed to save task to CoreData.")
        }

        delegate?.didCreateTask(title: taskDescription, dueDate: dueDateText)
        
        dismiss(animated: true, completion: nil)
    }

}


//import UIKit
//import SnapKit
//
//protocol CreateTaskViewControllerDelegate: AnyObject {
//    func didCreateTask(title: String, dueDate: String)
//}
//
//class CreateTaskViewController: UIViewController, UITextViewDelegate  {
//    
//    let createTaskTitleLabel = UILabel()
//    let dueDateLabel = UILabel()
//    let dueDateIcon = UIImageView()
//    let dueDateButton = UIButton()
//    let descriptionLabel = UILabel()
//    let descriptionIcon = UIImageView()
//    let descriptionTextView = UITextView()
//    var saveButton = UIButton()
//    let datePickerContainer = UIView()
//    let datePicker = UIDatePicker()
//    weak var delegate: CreateTaskViewControllerDelegate?
//    @objc var datePickerSelectButton = UIButton()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupView()
//        setupDatePickerContainer()
//        configureDatePicker()
//        descriptionTextView.delegate = self
//        saveButton.isEnabled = false
//        
//    }
//    
//    private func setupView() {
//        view.backgroundColor = .white
//        view.layer.cornerRadius = 16
//        
//        createTaskTitleLabel.text = "Create Task"
//        createTaskTitleLabel.textColor = UIColor(hex: "4C4C4C")
//        createTaskTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
//        view.addSubview(createTaskTitleLabel)
//        
//        createTaskTitleLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(16)
//            make.left.equalTo(28)
//        }
//        
//        dueDateIcon.image = UIImage(named: "Calendar")
//        view.addSubview(dueDateIcon)
//        
//        dueDateIcon.snp.makeConstraints { make in
//            make.top.equalTo(createTaskTitleLabel.snp.bottom).offset(20)
//            make.left.equalToSuperview().offset(28)
//            make.width.height.equalTo(20)
//        }
//        
//        dueDateLabel.text = "Due Date:"
//        dueDateLabel.textColor = UIColor(hex: "4C4C4C")
//        dueDateLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
//        view.addSubview(dueDateLabel)
//        
//        dueDateLabel.snp.makeConstraints { make in
//            make.centerY.equalTo(dueDateIcon)
//            make.left.equalTo(dueDateIcon.snp.right).offset(8)
//        }
//        
//        
//        dueDateButton.setTitle("Select Date", for: .normal)
//        dueDateButton.setTitleColor(UIColor(hex: "797979"), for: .normal)
//        dueDateButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
//        dueDateButton.layer.cornerRadius = 12
//        dueDateButton.layer.borderColor = UIColor(hex: "DADADA").cgColor
//        dueDateButton.layer.borderWidth = 0.5
//        dueDateButton.backgroundColor = UIColor(hex: "F6F6F6")
//        dueDateButton.contentHorizontalAlignment = .left
//        dueDateButton.addTarget(self, action: #selector(didTapDueDateButton), for: .touchUpInside)
//        dueDateButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
//
//
//        view.addSubview(dueDateButton)
//        
//        dueDateButton.snp.makeConstraints { make in
//            make.top.equalTo(dueDateLabel.snp.bottom).offset(8)
//            make.left.right.equalToSuperview().inset(22)
//            make.height.equalTo(50)
//        }
//        
//        let iconImageView = UIImageView(image: UIImage(named: "right"))
//        iconImageView.contentMode = .scaleAspectFit
//        dueDateButton.addSubview(iconImageView)
//        
//        iconImageView.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.right.equalToSuperview().offset(-12)
//            make.height.width.equalTo(24)
//        }
//        
//        descriptionIcon.image = UIImage(named: "PenNewSquare")
//        view.addSubview(descriptionIcon)
//        
//        descriptionIcon.snp.makeConstraints { make in
//            make.top.equalTo(dueDateButton.snp.bottom).offset(20)
//            make.left.equalToSuperview().offset(28)
//            make.width.height.equalTo(20)
//        }
//        
//        descriptionLabel.text = "Description:"
//        descriptionLabel.textColor = UIColor(hex: "4C4C4C")
//        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
//        view.addSubview(descriptionLabel)
//        
//        descriptionLabel.snp.makeConstraints { make in
//            make.centerY.equalTo(descriptionIcon)
//            make.left.equalTo(descriptionIcon.snp.right).offset(8)
//        }
//        
//        descriptionTextView.backgroundColor = UIColor(hex: "F6F6F6")
//        descriptionTextView.layer.borderColor = UIColor(hex: "D4D9DF").cgColor
//        descriptionTextView.layer.borderWidth = 0.5
//        descriptionTextView.layer.cornerRadius = 12
//        descriptionTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
//        descriptionTextView.textColor = UIColor(hex: "797979")
//        view.addSubview(descriptionTextView)
//        
//        descriptionTextView.snp.makeConstraints { make in
//            make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
//            make.left.right.equalToSuperview().inset(22)
//            make.height.equalTo(100)
//        }
//        
//        saveButton = UIButton.createCustomButton(of: .save, target: self, action: #selector(saveButtonTapped))
//        view.addSubview(saveButton)
//        
//        saveButton.snp.makeConstraints { make in
//            make.top.equalTo(descriptionTextView.snp.bottom).offset(24)
//            make.left.equalTo(24)
//            make.right.equalTo(-24)
//            make.height.equalTo(56)
//        }
//    }
//    
//    private func setupDatePickerContainer() {
//        datePickerContainer.backgroundColor = .white
//        datePickerContainer.layer.cornerRadius = 16
//        datePickerContainer.layer.borderColor = UIColor.lightGray.cgColor
//        datePickerContainer.isHidden = true
//        view.addSubview(datePickerContainer)
//
//        datePicker.datePickerMode = .date
//        datePicker.preferredDatePickerStyle = .wheels
//        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
//        datePickerContainer.addSubview(datePicker)
//
//        datePicker.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(16)
//            make.left.right.equalToSuperview().inset(16)
//            make.height.equalTo(200)
//        }
//
//        datePickerSelectButton = UIButton.createCustomButton(of: .selected, target: self, action: #selector(didSelectDate))
//        datePickerSelectButton.isEnabled = false 
//        datePickerContainer.addSubview(datePickerSelectButton)
//
//        datePickerSelectButton.snp.makeConstraints { make in
//            make.top.equalTo(datePicker.snp.bottom).offset(24)
//            make.left.equalTo(24)
//            make.right.equalTo(-24)
//            make.height.equalTo(56)
//        }
//        
//        datePickerContainer.snp.makeConstraints { make in
//            make.left.right.bottom.equalToSuperview()
//            make.height.equalTo(400)
//        }
//    }
//    
//    private func configureDatePicker() {
//        datePicker.minimumDate = Date()
//    }
//
//    @objc private func didTapDueDateButton() {
//        datePickerContainer.isHidden = false
//    }
//    
//    @objc private func datePickerValueChanged() {
//        datePickerSelectButton.isEnabled = true
//        datePickerSelectButton.backgroundColor = UIColor(hex: "FFAF5F")
//        checkIfSaveButtonShouldBeEnabled()
//    }
//    
//    func textViewDidChange(_ textView: UITextView) {
//       
//        checkIfSaveButtonShouldBeEnabled()
//    }
//    
//    private func checkIfSaveButtonShouldBeEnabled() {
//      
//        if let dueDateText = dueDateButton.titleLabel?.text, !dueDateText.contains("Select Date"),
//           !descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//            saveButton.isEnabled = true
//            saveButton.backgroundColor = UIColor(hex: "FFAF5F")
//        } else {
//            saveButton.isEnabled = false
//           
//        }
//    }
//    
//    @objc private func didSelectDate() {
//        let selectedDate = datePicker.date
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .none
//        let formattedDate = formatter.string(from: selectedDate)
//        
//        dueDateButton.setAttributedTitle(
//            NSAttributedString(
//                string: "       \(formattedDate)",
//                attributes: [
//                    .font: UIFont.systemFont(ofSize: 16, weight: .regular),
//                    .foregroundColor: UIColor(hex: "797979")
//                ]
//            ),
//            for: .normal
//        )
//        
//        datePickerContainer.isHidden = true
//    }
//    
//    @objc private func saveButtonTapped() {
//        guard let taskDescription = descriptionTextView.text,
//              !taskDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
//            print("Task description is empty.")
//            return
//        }
//        
//        let dueDate = dueDateButton.titleLabel?.text ?? "No Date Selected"
//        
//        print("Task Description: \(taskDescription)")
//        print("Due Date: \(dueDate)")
//
//        delegate?.didCreateTask(title: taskDescription, dueDate: dueDate)
//        
//        dismiss(animated: true, completion: nil)
//    }
//}
