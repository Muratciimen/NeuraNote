//
//  HomeVC.swift
//  ToDoList
//
//  Created by Murat Çimen on 16.10.2024.
//

import UIKit
import SnapKit
import CoreData

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CreateVCDelegate, TaskVCDelegate {

    let coreDataManager = CoreDataManager.shared
    let homeTitleLabel = UILabel()
    let homeSecondTitleLabel = UILabel()
    let homeCustomButton = CustomButton()
    let homeImageView = UIImageView()
    let homeEmptyLabel = UILabel()
    let tableView = UITableView()
    
    var categoryList: [Kategori] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData() 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchCategories()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name("TaskAdded"), object: nil)
    }

    @objc func reloadTableView() {
        fetchCategories()
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(hex: "F9F9F9")
        
        homeTitleLabel.text = "Home"
        homeTitleLabel.textAlignment = .left
        homeTitleLabel.textColor = UIColor(hex: "#484848")
        homeTitleLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        view.addSubview(homeTitleLabel)

        homeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).multipliedBy(0.1)
            make.left.equalTo(24)
        }

        homeSecondTitleLabel.text = "Create Category"
        homeSecondTitleLabel.textAlignment = .left
        homeSecondTitleLabel.textColor = UIColor(hex: "#484848")
        homeSecondTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        view.addSubview(homeSecondTitleLabel)

        homeSecondTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(homeTitleLabel.snp.bottom).offset(8)
            make.left.equalTo(24)
        }

        homeCustomButton.addTarget(self, action: #selector(didTapHomeCustomButton), for: .touchUpInside)
        view.addSubview(homeCustomButton)

        homeCustomButton.snp.makeConstraints { make in
            make.top.equalTo(homeSecondTitleLabel.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().inset(24)
            make.width.equalTo(380)
            make.height.equalTo(58)
        }

        homeImageView.image = UIImage(named: "note")
        homeImageView.contentMode = .scaleAspectFit
        homeImageView.alpha = 0.4
        view.addSubview(homeImageView)

        homeImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).multipliedBy(0.4)
            make.centerX.equalToSuperview()
            make.width.equalTo(117)
            make.height.equalTo(117)
        }

        homeEmptyLabel.text = "There is no to-do list created yet."
        homeEmptyLabel.textAlignment = .center
        homeEmptyLabel.textColor = UIColor(hex: "#484848")
        homeEmptyLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        homeEmptyLabel.alpha = 0.5
        view.addSubview(homeEmptyLabel)

        homeEmptyLabel.snp.makeConstraints { make in
            make.top.equalTo(homeImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(HomeCell.self, forCellReuseIdentifier: "HomeCell")
       
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(homeCustomButton.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }

        homeImageView.isHidden = true
        homeEmptyLabel.isHidden = true
    }

    func fetchCategories() {
        categoryList = coreDataManager.fetchAllCategories()
        tableView.reloadData()
        updateViewVisibility()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as? HomeCell else {
            return UITableViewCell()
        }

        let category = categoryList[indexPath.row]

        if let colorData = category.color,
           let color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor {
            cell.configure(title: category.name ?? "Untitled", taskCount: category.items?.count ?? 0, color: color)
        } else {
            cell.configure(title: category.name ?? "Untitled", taskCount: category.items?.count ?? 0, color: .white)
        }
        cell.selectionStyle = .none
        return cell
    }

    @objc func didTapHomeCustomButton() {
        let newVC = CreateVC()
        newVC.delegate = self
        navigationController?.pushViewController(newVC, animated: true)
    }

    func didCreateTask(task: String, color: UIColor, category: Kategori) {
        categoryList.append(category)
        tableView.reloadData()
        updateViewVisibility()
    }

    private func updateViewVisibility() {
        if categoryList.isEmpty {
            homeImageView.isHidden = false
            homeEmptyLabel.isHidden = false
            tableView.isHidden = true
        } else {
            homeImageView.isHidden = true
            homeEmptyLabel.isHidden = true
            tableView.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categoryList[indexPath.row]
        let taskVC = TaskVC()
        taskVC.taskTitle = category.name
        taskVC.category = category
        taskVC.delegate = self 
        navigationController?.pushViewController(taskVC, animated: true)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let categoryToDelete = categoryList[indexPath.row]
            coreDataManager.deleteCategory(category: categoryToDelete)
            categoryList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            NotificationCenter.default.post(name: NSNotification.Name("CategoryDeleted"), object: nil)
            updateViewVisibility()
        }
    }
    
    func didUpdateTaskCount() {
        fetchCategories()
    }
}
