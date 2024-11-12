//
//  CreateTaskViewController.swift
//  ToDoList
//
//  Created by Murat Çimen on 4.11.2024.
//

import UIKit
import SnapKit
import UserNotifications

protocol CreateTaskViewControllerDelegate: AnyObject {
    func didCreateTask(title: String, dueDate: String, reminderTime: String, category: Kategori)
}

class CreateTaskViewController: UIViewController, UITextViewDelegate {
    
    var isEditMode: Bool = false
    var taskToEdit: ToDoListitem?
    var taskTitle: String?
    var dueDate: String?
    var reminderTime: String?
    var descriptionText: String?
    var category: Kategori?
    
    let createTaskTitleLabel = UILabel()
    let dueDateLabel = UILabel()
    let dueDateIcon = UIImageView()
    let dueDateButton = UIButton()
    let reminderLabel = UILabel()
    let reminderIcon = UIImageView()
    let reminderButton = UIButton()
    let descriptionLabel = UILabel()
    let descriptionIcon = UIImageView()
    let descriptionTextView = UITextView()
    var saveButton = UIButton()
    let datePickerContainer = UIView()
    let datePicker = UIDatePicker()
    let reminderPickerContainer = UIView()
    let reminderDatePicker = UIDatePicker()
    weak var delegate: CreateTaskViewControllerDelegate?
   
    private var isTaskSaved = false
    var dueDateText: String?
    
    @objc var datePickerSelectButton = UIButton()
    @objc var reminderPickerSelectButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupDatePickerContainer()
        setupReminderPickerContainer()
        configureDatePicker()
        
        print("Category in CreateTaskViewController viewDidLoad:", category?.name ?? "Category is nil")
        
        if isEditMode {
            createTaskTitleLabel.text = "Edit Task"
            loadTaskData()
        } else {
            createTaskTitleLabel.text = "Create Task"
        }
        
        descriptionTextView.delegate = self
        saveButton.isEnabled = false
         
    }
    
    private func loadTaskData() {
        createTaskTitleLabel.text = isEditMode ? "Edit Task" : "Create Task"
        dueDateButton.setTitle("       \(dueDate ?? "Select Date")", for: .normal)
        reminderButton.setTitle("       \(reminderTime ?? "Select Reminder")", for: .normal)
        
        descriptionTextView.text = taskTitle ?? ""
        category = taskToEdit?.category
        
        saveButton.isEnabled = true
        saveButton.backgroundColor = UIColor(hex: "FFAF5F")
    }
    
    // MARK: - UI Kurulumu
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
        
        reminderIcon.image = UIImage(named: "Alarm")
        view.addSubview(reminderIcon)
        
        reminderIcon.snp.makeConstraints { make in
            make.top.equalTo(dueDateButton.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(28)
            make.width.height.equalTo(20)
        }
        
        reminderLabel.text = "Reminder at:"
        reminderLabel.textColor = UIColor(hex: "4C4C4C")
        reminderLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        view.addSubview(reminderLabel)
        
        reminderLabel.snp.makeConstraints { make in
            make.centerY.equalTo(reminderIcon)
            make.left.equalTo(reminderIcon.snp.right).offset(8)
        }
        
        reminderButton.setTitle("Select Reminder", for: .normal)
        reminderButton.setTitleColor(UIColor(hex: "797979"), for: .normal)
        reminderButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        reminderButton.layer.cornerRadius = 12
        reminderButton.layer.borderColor = UIColor(hex: "DADADA").cgColor
        reminderButton.layer.borderWidth = 0.5
        reminderButton.backgroundColor = UIColor(hex: "F6F6F6")
        reminderButton.contentHorizontalAlignment = .left
        reminderButton.addTarget(self, action: #selector(didTapReminderButton), for: .touchUpInside)
        reminderButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        view.addSubview(reminderButton)
        
        reminderButton.snp.makeConstraints { make in
            make.top.equalTo(reminderLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(22)
            make.height.equalTo(50)
        }
        
        let reminderIconImageView = UIImageView(image: UIImage(named: "right"))
        reminderIconImageView.contentMode = .scaleAspectFit
        reminderButton.addSubview(reminderIconImageView)
        
        reminderIconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
            make.height.width.equalTo(24)
        }
        
        descriptionIcon.image = UIImage(named: "PenNewSquare")
        view.addSubview(descriptionIcon)
        
        descriptionIcon.snp.makeConstraints { make in
            make.top.equalTo(reminderButton.snp.bottom).offset(20)
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
            make.top.equalTo(descriptionTextView.snp.bottom).offset(16)
            make.left.equalTo(24)
            make.right.equalTo(-24)
            make.height.equalTo(56)
        }
    }
    
    // MARK: - DatePicker Kurulumu
    private func setupDatePickerContainer() {
        datePickerContainer.backgroundColor = .white
        datePickerContainer.tintColor = .black
        datePickerContainer.layer.cornerRadius = 16
        datePickerContainer.layer.borderColor = UIColor.lightGray.cgColor
        datePickerContainer.isHidden = true
        datePicker.overrideUserInterfaceStyle = .light
        view.addSubview(datePickerContainer)

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        datePickerContainer.addSubview(datePicker)

        datePicker.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(300)
        }

        datePickerSelectButton = UIButton.createCustomButton(of: .selected, target: self, action: #selector(didSelectDate))
        datePickerSelectButton.backgroundColor = UIColor(hex: "FFAF5F")
        datePickerContainer.addSubview(datePickerSelectButton)

        datePickerSelectButton.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(24)
            make.left.equalTo(24)
            make.right.equalTo(-24)
            make.height.equalTo(56)
        }

        datePickerContainer.snp.makeConstraints { make in
            make.top.equalTo(40)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(400)
        }
    }
    
    // MARK: - Reminder Picker Kurulumu
    private func setupReminderPickerContainer() {
        reminderPickerContainer.backgroundColor = .white
        reminderPickerContainer.tintColor = .black
        reminderPickerContainer.layer.cornerRadius = 16
        reminderPickerContainer.layer.borderColor = UIColor.lightGray.cgColor
        reminderPickerContainer.isHidden = true
        reminderDatePicker.overrideUserInterfaceStyle = .light 
        view.addSubview(reminderPickerContainer)
        
        reminderDatePicker.datePickerMode = .time
        reminderDatePicker.preferredDatePickerStyle = .wheels
        reminderPickerContainer.addSubview(reminderDatePicker)
        
        reminderDatePicker.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(300)
        }
        
        reminderPickerSelectButton = UIButton.createCustomButton(of: .selected, target: self, action: #selector(didSelectReminderTime))
        reminderPickerSelectButton.backgroundColor = UIColor(hex: "FFAF5F")
        reminderPickerContainer.addSubview(reminderPickerSelectButton)
        
        reminderPickerSelectButton.snp.makeConstraints { make in
            make.top.equalTo(reminderDatePicker.snp.bottom).offset(24)
            make.left.equalTo(24)
            make.right.equalTo(-24)
            make.height.equalTo(56)
        }
        
        reminderPickerContainer.snp.makeConstraints { make in
            make.top.equalTo(40)
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
    
    @objc private func didTapReminderButton() {
        reminderPickerContainer.isHidden = false
    }
    
    @objc private func datePickerChanged(_ sender: UIDatePicker) {
       
        updateReminderMinimumTime(for: sender.date)
    }

    private func updateReminderMinimumTime(for selectedDate: Date) {
        let calendar = Calendar.current
        let currentDate = Date()
        if calendar.isDate(selectedDate, inSameDayAs: currentDate) {
            reminderDatePicker.minimumDate = currentDate
        } else {
            reminderDatePicker.minimumDate = nil
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
                string: "\(formattedDate)",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 16, weight: .regular),
                    .foregroundColor: UIColor(hex: "797979")
                ]
            ),
            for: .normal
        )
    
        updateReminderMinimumTime(for: selectedDate)
        checkIfSaveButtonShouldBeEnabled()
        
        datePickerContainer.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkIfSaveButtonShouldBeEnabled()
    }
    
    @objc private func didSelectReminderTime() {
        let selectedTime = reminderDatePicker.date
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        let formattedTime = formatter.string(from: selectedTime)
        
        reminderButton.setAttributedTitle(
            NSAttributedString(
                string: "\(formattedTime)",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 16, weight: .regular),
                    .foregroundColor: UIColor(hex: "797979")
                ]
            ),
            for: .normal
        )
        
        reminderTime = formattedTime
        
        checkIfSaveButtonShouldBeEnabled()
        reminderPickerContainer.isHidden = true
    }
    
    private func checkIfSaveButtonShouldBeEnabled() {
        if let dueDateText = dueDateButton.titleLabel?.text, !dueDateText.contains("Select Date"),
           let reminderText = reminderButton.titleLabel?.text, !reminderText.contains("Select Reminder"),
           !descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            saveButton.isEnabled = true
            saveButton.backgroundColor = UIColor(hex: "FFAF5F")
        } else {
            saveButton.isEnabled = false
        }
    }
    
    // MARK: - Görev Kaydetme İşlemi
    @objc private func saveButtonTapped() {
        print("Category in saveButtonTapped at start:", category?.name ?? "Category is nil")

        guard !isTaskSaved else {
            print("Task is already saved.")
            return
        }
        
        isTaskSaved = true
        
        guard let taskDescription = descriptionTextView.text,
              !taskDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("Task description is empty.")
            isTaskSaved = false
            return
        }

        let dueDateString = dueDateButton.titleLabel?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let dueDateText = dueDateString, !dueDateText.contains("Select Date") else {
            print("Due date not selected.")
            isTaskSaved = false
            return
        }

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        guard let dueDate = formatter.date(from: dueDateText) else {
            print("Invalid due date format.")
            isTaskSaved = false
            return
        }

        if isEditMode, let taskToEdit = taskToEdit {
            category = taskToEdit.category
        }

        if !isEditMode, category == nil {
            print("Category is missing.")
            isTaskSaved = false
            return
        }

        let reminderTimeString = reminderButton.titleLabel?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let reminderTimeDate = timeFormatter.date(from: reminderTimeString)

        if isEditMode, let taskToEdit = taskToEdit {
            let success = CoreDataManager.shared.updateItem(
                item: taskToEdit,
                newName: taskDescription,
                newDueDate: dueDate,
                newReminderTime: reminderTimeDate
            )
            if success {
                print("Task successfully updated in CoreData.")
                if let existingCategory = taskToEdit.category {
                    delegate?.didCreateTask(title: taskDescription, dueDate: dueDateText, reminderTime: reminderTimeString, category: existingCategory)
                }
            } else {
                print("Failed to update task in CoreData.")
                isTaskSaved = false
            }
        } else {
            if let savedTask = CoreDataManager.shared.createItem(
                name: taskDescription,
                dueDate: dueDate,
                reminderTime: reminderTimeDate,
                color: UIColor.systemBlue,
                category: category!
            ) {
                print("Task successfully saved to CoreData.")
                delegate?.didCreateTask(title: taskDescription, dueDate: dueDateText, reminderTime: reminderTimeString, category: category!)
            } else {
                print("Failed to save task to CoreData.")
                isTaskSaved = false
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}
