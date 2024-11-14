//
//  CalenderVC.swift
//  ToDoList
//
//  Created by Murat Çimen on 1.11.2024.
//

import UIKit
import SnapKit
import FSCalendar
import CoreData

class CalenderVC: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, UITableViewDataSource, UITableViewDelegate {

    let calendarView = FSCalendar()
    let calenderTitleLabel = UILabel()
    let todayTitleLabel = UILabel()
    let tasksTableView = UITableView()
    var taskDatesWithColors: [Date: UIColor] = [:]
    var tasks: [ToDoListitem] = []
    var taskTitle: String?
    var dueDate: String?
    var reminderTime: String?
    var category: Category?
    var taskToEdit: ToDoListitem?
    let titleLabel = UILabel()
    let dueDateLabel = UILabel()
    let reminderTimeLabel = UILabel()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadTasks(for: calendarView.selectedDate ?? Date())
        tasksTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadTasks(for: Date())
        updateTaskDatesWithColors()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCalendar), name: NSNotification.Name("TaskUpdated"), object: nil)
        
        if let title = taskTitle {
            titleLabel.text = title
        }

        dueDateLabel.text = dueDate
        reminderTimeLabel.text = reminderTime
    }

    func setupUI() {
        view.backgroundColor = UIColor(hex: "F9F9F9")
        
        calenderTitleLabel.text = "Calendar"
        calenderTitleLabel.textAlignment = .center
        calenderTitleLabel.textColor = UIColor(hex: "#484848")
        calenderTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        view.addSubview(calenderTitleLabel)
        
        calenderTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
        
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.select(Date())
        
        calendarView.appearance.headerTitleFont = UIFont.systemFont(ofSize: 16, weight: .regular)
        calendarView.appearance.weekdayFont = UIFont.systemFont(ofSize: 14, weight: .medium)
        calendarView.appearance.headerTitleColor = UIColor(hex: "FFAF5F")
        calendarView.appearance.weekdayTextColor = UIColor(hex: "FFAF5F")
        calendarView.appearance.todayColor = .clear
        calendarView.appearance.titleTodayColor = .black
        calendarView.appearance.selectionColor = UIColor(hex: "FFAF5F")
        calendarView.appearance.eventDefaultColor = .purple
        calendarView.appearance.borderRadius = 0.5
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        
        view.addSubview(calendarView)
        
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(calenderTitleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(300)
        }
        
        todayTitleLabel.text = "Today Task"
        todayTitleLabel.textAlignment = .left
        todayTitleLabel.textColor = UIColor(hex: "#484848")
        todayTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        view.addSubview(todayTitleLabel)
        
        todayTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(20)
            make.left.equalTo(24)
        }
        
        tasksTableView.separatorStyle = .none
        tasksTableView.backgroundColor = .clear
        tasksTableView.rowHeight = UITableView.automaticDimension
        tasksTableView.estimatedRowHeight = 44
        tasksTableView.register(CalenderCell.self, forCellReuseIdentifier: "CalenderCell")
        
        view.addSubview(tasksTableView)
        
        tasksTableView.snp.makeConstraints { make in
            make.top.equalTo(todayTitleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        tasksTableView.dataSource = self
        tasksTableView.delegate = self
    }
    
    func updateTaskDatesWithColors() {
        calendarView.reloadData()
        taskDatesWithColors = CoreDataManager.shared.fetchTaskDatesWithCategoryColors()
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        loadTasks(for: date)
    }

    func loadTasks(for date: Date) {
        tasks = CoreDataManager.shared.fetchItems(forDate: date)
        tasksTableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if let color = taskDatesWithColors.first(where: { Calendar.current.isDate($0.key, inSameDayAs: date) })?.value {
            return color
        }
        return nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalenderCell", for: indexPath) as? CalenderCell else {
            return UITableViewCell()
        }
        
        let task = tasks[indexPath.row]
        cell.configureCell(title: task.name ?? "", isChecked: task.isCompleted)
        
        cell.checkBoxTapped = { [weak self] in
            guard let self = self else { return }
            task.isCompleted.toggle()
            CoreDataManager.shared.saveContext()
            self.tasksTableView.reloadRows(at: [indexPath], with: .automatic)
            self.updateTaskDatesWithColors()
            self.calendarView.reloadData()
        }
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = tasks[indexPath.row]
            CoreDataManager.shared.deleteItem(item: taskToDelete)
            tasks.remove(at: indexPath.row)
            tasksTableView.deleteRows(at: [indexPath], with: .automatic)
            
            updateTaskDatesWithColors()
            calendarView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
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

        taskDetailVC.category = task.category
        taskDetailVC.taskToEdit = task
        
        navigationController?.pushViewController(taskDetailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
    @objc func refreshCalendar() {
        updateTaskDatesWithColors()
        calendarView.reloadData()
    }
}
