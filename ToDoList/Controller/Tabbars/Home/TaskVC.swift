//
//  TaskVC.swift
//  ToDoList
//
//  Created by Murat Çimen on 3.11.2024.
//
//

import UIKit
import SnapKit


protocol TaskVCDelegate: AnyObject {
    func didUpdateTaskCount()
}

class TaskVC: UIViewController, UITableViewDataSource, UITableViewDelegate, CreateTaskViewControllerDelegate {

    weak var delegate: TaskVCDelegate?
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
        showOverlayIfFirstLaunch()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        tableView.addGestureRecognizer(longPressGesture)
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
          
            tasks = CoreDataManager.shared.fetchItems(byCategory: category).sorted(by: { $0.createdAt ?? Date() > $1.createdAt ?? Date() })
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

    func didCreateTask(title: String, dueDate: String, reminderTime: String, category: Kategori) {
        loadTasks()
        delegate?.didUpdateTaskCount()
        NotificationCenter.default.post(name: NSNotification.Name("TaskUpdated"), object: nil)
    }
    // MARK: - İlk Açılış Kontrolü ve Overlay Gösterimi
    
    func showOverlayIfFirstLaunch() {
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        
        if !isFirstLaunch {
            
            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
            
           
            overlayImageView.image = UIImage(named: "tip")
            overlayImageView.contentMode = .scaleAspectFill
            overlayImageView.alpha = 0.0
            overlayImageView.isUserInteractionEnabled = true
            view.addSubview(overlayImageView)
            overlayImageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                UIView.animate(withDuration: 0.5) {
                    self?.overlayImageView.alpha = 1.0
                }
            }
            
         
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissOverlay))
            overlayImageView.addGestureRecognizer(tapGesture)
        }
    }

    @objc private func dismissOverlay() {
        UIView.animate(withDuration: 0.5, animations: {
            self.overlayImageView.alpha = 0.0
        }) { _ in
            self.overlayImageView.removeFromSuperview()
        }
    }


    // MARK: - UITableView DataSource & Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        let taskDetailVC = TaskDetail()
        
        print("Category in didSelectRowAt:", task.category?.name ?? "Category is nil")
        
        taskDetailVC.taskTitle = task.name
        taskDetailVC.dueDate = task.dueDate != nil ? DateFormatter.localizedString(from: task.dueDate!, dateStyle: .medium, timeStyle: .none) : "No Date Selected"

        if let reminderTime = task.reminderTime {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            taskDetailVC.reminderTime = timeFormatter.string(from: reminderTime)
        } else {
            taskDetailVC.reminderTime = "No Reminder Set"
        }

        taskDetailVC.category = task.category
        taskDetailVC.taskToEdit = task
        
        navigationController?.pushViewController(taskDetailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
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
            
            DispatchQueue.main.async {
                if CoreDataManager.shared.saveContext() {
                    tableView.reloadData()
                }
            }
        }
        
        cell.buttonTappedAction = { [weak self] in
            guard let self = self else { return }
            
            let taskDetailVC = TaskDetail()
            taskDetailVC.taskTitle = task.name
            taskDetailVC.dueDate = task.dueDate != nil ? DateFormatter.localizedString(from: task.dueDate!, dateStyle: .medium, timeStyle: .none) : "No Date Selected"
            
            if let reminderTime = task.reminderTime {
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                taskDetailVC.reminderTime = timeFormatter.string(from: reminderTime)
            } else {
                taskDetailVC.reminderTime = "No Reminder Set"
            }
            
            self.navigationController?.pushViewController(taskDetailVC, animated: true)
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = tasks[indexPath.row]
            
            let isDeleted = CoreDataManager.shared.deleteItem(item: taskToDelete)
            
            if isDeleted {
                tasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                updateEmptyState()
                
                delegate?.didUpdateTaskCount()
            } else {
                print("Error deleting task from Core Data")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedTask = tasks.remove(at: sourceIndexPath.row)
        tasks.insert(movedTask, at: destinationIndexPath.row)
        
        for (index, task) in tasks.enumerated() {
            task.index = Int32(index)
        }
        CoreDataManager.shared.saveContext()
    }

    @objc private func didTapBackButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            tableView.setEditing(!tableView.isEditing, animated: true)
        default:
            break
        }
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

