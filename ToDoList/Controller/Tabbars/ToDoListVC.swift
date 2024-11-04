//
//  ViewController.swift
//  ToDoList
//
//  Created by Murat Çimen on 14.10.2024.
//

//import UIKit
//import SnapKit
//import CoreData
//
//class ToDoListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    
//    let tableView: UITableView = {
//        let table = UITableView()
//        table.estimatedRowHeight = 100
//        table.rowHeight = UITableView.automaticDimension
//        table.register(ToDoListCell.self, forCellReuseIdentifier: "ToDoListCell")
//        return table
//    }()
//    
//    let segmentedControl = UISegmentedControl(items: ["Yapılmayanlar", "Yapılanlar"])
//    private var models = [ToDoListitem]()
//    private var filteredModels = [ToDoListitem]()
//    
// 
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//       
//        DispatchQueue.main.async { [self] in
//            getAllItems()
//            tableView.reloadData()
//        }
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.backgroundColor = UIColor(hex: "#EEEEEE")
//        setupUI()
//        getAllItems()  
//    }
//    
//    func setupUI() {
//        let titleLabel = UILabel()
//        titleLabel.text = "To Do List"
//        titleLabel.textColor = UIColor(hex: "#4a4949")
//        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
//        titleLabel.textAlignment = .left
//        titleLabel.sizeToFit()
//        
//        view.addSubview(titleLabel)
//        
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).multipliedBy(0.1)
//            make.left.equalTo(16)
//        }
//        
//        let addButton = UIButton(type: .system)
//        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
//        addButton.tintColor = UIColor(hex: "#4a4949")
//        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
//        
//        view.addSubview(addButton)
//        addButton.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).multipliedBy(0.1)
//            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).inset(24)
//            make.height.equalTo(40)
//            make.width.equalTo(40)
//        }
//        
//        segmentedControl.selectedSegmentIndex = 0
//        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
//        view.addSubview(segmentedControl)
//        segmentedControl.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.bottom).offset(10)
//            make.left.equalTo(16)
//            make.right.equalTo(-16)
//        }
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.separatorStyle = .none
//        tableView.backgroundColor = .clear
//        tableView.estimatedRowHeight = 100
//        tableView.rowHeight = UITableView.automaticDimension
//        view.addSubview(tableView)
//        
//        tableView.snp.makeConstraints { make in
//            make.top.equalTo(segmentedControl.snp.bottom).offset(24)
//            make.left.equalTo(16)
//            make.right.equalTo(-16)
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//        }
//    }
//    
//    @objc func segmentedControlChanged(_ sender: UISegmentedControl) {
//        filterItems()
//        tableView.reloadData()
//    }
//    
//    func filterItems() {
//        if segmentedControl.selectedSegmentIndex == 0 {
//            filteredModels = models.filter { !$0.isCompleted }
//        } else {
//            filteredModels = models.filter { $0.isCompleted }
//        }
//    }
//    
//    func getAllItems() {
//        let request = ToDoListitem.fetchRequest() as NSFetchRequest<ToDoListitem>
//        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
//        request.sortDescriptors = [sortDescriptor]
//        
//        do {
//            models = try context.fetch(request)
//            filterItems()
//        }
//        catch {
//            print("Error fetching data from context: \(error)")
//        }
//    }
//
//    func createItem(name: String, dueDate: Date) {
//        let newItem = ToDoListitem(context: context)
//        newItem.name = name
//        newItem.createdAt = Date()
//        newItem.dueDate = dueDate
//        newItem.index = Int32(models.count)
//
//        do {
//            try context.save()
//            getAllItems()
//        }
//        catch {
//            print("Error saving context: \(error)")
//        }
//    }
//    
//    func deleteItem(item: ToDoListitem) {
//        context.delete(item)
//        
//        do {
//            try context.save()
//            getAllItems()
//        }
//        catch {
//            print("Error deleting item: \(error)")
//        }
//    }
//
//    func updateItem(item: ToDoListitem, newName: String, newDueDate: Date) {
//        item.name = newName
//        item.dueDate = newDueDate
//        
//        do {
//            try context.save()
//            getAllItems()
//        }
//        catch {
//            print("Error updating item: \(error)")
//        }
//    }
//    
//    @objc func didTapAddButton() {
//        let addItemVC = TextVC()
//        
//        
//        addItemVC.onSave = { [weak self] name, dueDate in
//            self?.createItem(name: name, dueDate: dueDate)
//        }
//        
//        present(addItemVC, animated: true, completion: nil)
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return filteredModels.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let model = filteredModels[indexPath.row]
//        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath) as? ToDoListCell else {
//            return UITableViewCell()
//        }
//        
//        cell.configureCell(title: model.name ?? "No Name", isChecked: model.isCompleted)
//        
//        cell.checkBoxTapped = { [weak self] in
//            model.isCompleted.toggle()
//            
//            do {
//                try self?.context.save()
//                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
//            } catch {
//                print("Error saving completion status: \(error)")
//            }
//        }
//        
//        cell.backgroundColor = .clear
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
//            let itemToDelete = self?.filteredModels[indexPath.row]
//            
//            if let item = itemToDelete {
//                self?.deleteItem(item: item)
//            }
//            
//            completionHandler(true)
//        }
//        
//        deleteAction.backgroundColor = .red
//        
//        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
//        return configuration
//    }
//    
//    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let movedItem = models.remove(at: sourceIndexPath.row)
//        models.insert(movedItem, at: destinationIndexPath.row)
//        
//        for (index, item) in models.enumerated() {
//            item.index = Int32(index)
//        }
//        
//        do {
//            try context.save()
//        } catch {
//            print("Error updating item order: \(error)")
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let item = filteredModels[indexPath.row]
//        
//        if item.isCompleted {
//            let alert = UIAlertController(title: "Item Completed", message: "This item is completed and cannot be edited.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            present(alert, animated: true)
//            return
//        }
//        
//        let editItemVC = TextVC()
//        
//        editItemVC.textView.text = item.name
//        editItemVC.selectedDate = item.dueDate
//        
//        editItemVC.onSave = { [weak self] name, dueDate in
//            self?.updateItem(item: item, newName: name, newDueDate: dueDate)
//        }
//        
//        present(editItemVC, animated: true, completion: nil)
//    }
//}
