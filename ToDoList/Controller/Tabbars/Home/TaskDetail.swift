//
//  TaskDetail.swift
//  ToDoList
//
//  Created by Murat Çimen on 7.11.2024.

import UIKit
import SnapKit

class TaskDetail: UIViewController, CreateTaskViewControllerDelegate {
    
    var taskTitle: String?
    var dueDate: String?
    var reminderTime: String?
    var descriptionText: String?
    var category: Kategori?
    var taskToEdit: ToDoListitem?
    var titleLabel = UILabel()
    let dateView = UIView()
    let dueDateIcon = UIImageView()
    let dueDateLabel = UILabel()
    let dateLabel = UILabel()
    let reminderView = UIView()
    let reminderIcon = UIImageView()
    let reminderLabel = UILabel()
    let reminderSecondLabel = UILabel()
    let briefLabel = UILabel()
    let briefView = UIView()
    let briefIcon = UIImageView()
    let imageView = UIImageView()
    var editButton = UIButton()
    let apiManager = APIManager()
    var task: ToDoListitem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureNavigationBar()
        
        titleLabel.text = taskTitle
        dateLabel.text = dueDate ?? "No Date Selected"
        reminderSecondLabel.text = reminderTime ?? "No Reminder Set"
        
        fetchBrief() 
    }
    
    func didCreateTask(title: String, dueDate: String,reminderTime: String, category: Kategori) {
        self.taskTitle = title
        self.dueDate = dueDate
        self.reminderTime = reminderTime
        self.category = category
        
       
        titleLabel.text = title
        dateLabel.text = dueDate
        reminderSecondLabel.text = reminderTime
        print("Task updated with title: \(title), dueDate: \(dueDate), category: \(category.name)")
    }
    
    func fetchBrief() {
        
        guard let taskTitle = taskTitle else {
            briefLabel.text = "Görev başlığı bulunamadı."
            return
        }
        
        
        if let savedBrief = UserDefaults.standard.string(forKey: taskTitle) {
            briefLabel.text = savedBrief
            return
        }
        
        
        apiManager.fetchGeminiContent(prompt: taskTitle) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let briefText):
                    self?.briefLabel.text = briefText
                    UserDefaults.standard.set(briefText, forKey: taskTitle)
                case .failure(let error):
                    self?.briefLabel.text = "Brief alınamadı: \(error.localizedDescription)"
                }
            }
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
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor(hex: "#4a4949")
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        
        dateView.backgroundColor = UIColor(hex: "F6F6F6")
        dateView.layer.borderColor = UIColor(hex: "DADADA").cgColor
        dateView.layer.cornerRadius = 12
        dateView.layer.borderWidth = 0.5
        view.addSubview(dateView)
        
        dateView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
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
        dateLabel.textColor = .black
        dateLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        dateView.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
        
        reminderView.backgroundColor = UIColor(hex: "F6F6F6")
        reminderView.layer.borderColor = UIColor(hex: "DADADA").cgColor
        reminderView.layer.cornerRadius = 12
        reminderView.layer.borderWidth = 0.5
        view.addSubview(reminderView)
        
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
            make.left.equalTo(reminderIcon.snp.right).offset(8)
        }
        
        reminderSecondLabel.text = ""
        reminderSecondLabel.textColor = .black
        reminderSecondLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        reminderView.addSubview(reminderSecondLabel)
        
        reminderSecondLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
        
        briefView.layer.borderColor = UIColor(hex: "7091ED").cgColor
        briefView.layer.cornerRadius = 12
        briefView.layer.borderWidth = 1
        briefView.clipsToBounds = true
        view.addSubview(briefView)

        briefView.snp.makeConstraints { make in
            make.top.equalTo(reminderView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        
        imageView.image = UIImage(named: "Input")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        briefView.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        briefIcon.image = UIImage(named: "Ai")
        briefView.addSubview(briefIcon)
        
        briefIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(24)
            make.width.height.equalTo(20)
        }
        
        briefLabel.textAlignment = .left
        briefLabel.textColor = UIColor(hex: "4C4C4C")
        briefLabel.numberOfLines = 0
        briefLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        briefView.addSubview(briefLabel)

        briefLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(briefIcon.snp.right).offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        editButton.backgroundColor = UIColor(hex: "FFAF5F")
        editButton = UIButton.createCustomButton(of: .editTask, target: self, action: #selector(editButtonTapped))
        view.addSubview(editButton)
        
        editButton.snp.makeConstraints { make in
            make.top.equalTo(briefLabel.snp.bottom).offset(24)
            make.left.equalTo(24)
            make.right.equalTo(-24)
            make.height.equalTo(56)
        }
        
    }
    
    @objc private func editButtonTapped() {
        let createTaskVC = CreateTaskViewController()
        
        createTaskVC.isEditMode = true
        createTaskVC.taskTitle = taskTitle
        createTaskVC.dueDate = dueDate
        createTaskVC.reminderTime = reminderTime
        createTaskVC.descriptionText = descriptionText
        createTaskVC.taskToEdit = self.taskToEdit
        createTaskVC.category = category
        
        createTaskVC.delegate = self
        
        createTaskVC.modalPresentationStyle = .pageSheet
        
        if let sheet = createTaskVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        present(createTaskVC, animated: true, completion: nil)
    }
    func configureNavigationBar() {
        navigationItem.title = ""
        navigationItem.hidesBackButton = true
    }
}
