//
//  TaskVC.swift
//  ToDoList
//
//  Created by Murat Çimen on 3.11.2024.
//

import UIKit
import SnapKit

class TaskVC: UIViewController, UITableViewDataSource, UITableViewDelegate, CreateTaskViewControllerDelegate {

    let backButton = UIButton()
    let titleLabel = UILabel()
    let plusButton = UIButton()
    let taskImageView = UIImageView()
    let taskEmptyLabel = UILabel()
    lazy var overlayImageView = UIImageView()
    let tableView = UITableView()
    
    var category: Kategori?
    var taskTitle: String?
    var tasks: [ToDoListitem] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTasks() 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupUI()
        
        if let taskTitle = taskTitle {
            titleLabel.text = taskTitle
        }
        
        loadTasks()
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
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(ToDoListCell.self, forCellReuseIdentifier: "ToDoListCell")
        tableView.isHidden = tasks.isEmpty
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
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

        updateEmptyState()
    }

    func loadTasks() {
        if let category = category {
            tasks = CoreDataManager.shared.fetchItems(byCategory: category)
        } else {
            tasks = []
        }
        tableView.isHidden = tasks.isEmpty
        updateEmptyState()
        tableView.reloadData()
    }

    func updateEmptyState() {
        let isTaskListEmpty = tasks.isEmpty
        taskImageView.isHidden = !isTaskListEmpty
        taskEmptyLabel.isHidden = !isTaskListEmpty
    }

    func didCreateTask(title: String, dueDate: String, category: Kategori) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none

            if let dueDateObject = formatter.date(from: dueDate) {
                if let newTask = CoreDataManager.shared.createItem(name: title, dueDate: dueDateObject, color: UIColor.systemBlue, category: category) {
                    print("New task added to CoreData: \(newTask)")
                    loadTasks()
                } else {
                    print("Failed to add task to CoreData")
                }
            } else {
                print("Failed to create task: invalid due date")
            }
        }

    // MARK: - UITableView DataSource & Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath) as? ToDoListCell else {
            return UITableViewCell()
        }
        
        let task = tasks[indexPath.row]
        cell.configureCell(title: task.name ?? "", isChecked: task.isCompleted)
        
        cell.checkBoxTapped = { [weak self] in
            guard let self = self else { return }
            task.isCompleted.toggle()
            if CoreDataManager.shared.saveContext() {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @objc private func didTapBackButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func didTapPlusButton() {
        let createTaskVC = CreateTaskViewController()
        createTaskVC.delegate = self
        createTaskVC.category = self.category 

        if let sheet = createTaskVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        createTaskVC.modalPresentationStyle = .pageSheet
        present(createTaskVC, animated: true, completion: nil)
    }

    func configureNavigationBar() {
        navigationItem.title = ""
        navigationItem.hidesBackButton = true
    }
}

