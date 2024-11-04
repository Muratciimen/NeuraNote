//
//  BrifVC.swift
//  ToDoList
//
//  Created by Murat Çimen on 25.10.2024.
//

import UIKit
import CoreData
import SnapKit

class BriefVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let briefTitleLabel = UILabel()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let tableView = UITableView()
    private var notes = [ToDoListitem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchAllNotes()
    }
    
    func setupUI() {
        
        briefTitleLabel.text = "Briefs"
        briefTitleLabel.textAlignment = .left
        briefTitleLabel.textColor = UIColor(hex: "#4a4949")
        briefTitleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        view.addSubview(briefTitleLabel)
        
        briefTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).multipliedBy(0.1)
            make.left.equalTo(16)
        }
        
        view.backgroundColor = UIColor(hex: "#EEEEEE")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(briefTitleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(BriefCell.self, forCellReuseIdentifier: "BriefCell")
    }
    
   
    func fetchAllNotes() {
        let request = ToDoListitem.fetchRequest() as NSFetchRequest<ToDoListitem>
        do {
            notes = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error fetching notes from Core Data: \(error)")
        }
    }

   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = notes[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BriefCell", for: indexPath) as? BriefCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(title: note.name ?? "No Title", brief: note.brief ?? "Loading brief...", isChecked: note.isCompleted)
        
     
        if note.brief == nil || note.brief == "" {
            fetchBrief(for: note, at: indexPath)
        }
        
        return cell
    }

    func fetchBrief(for note: ToDoListitem, at indexPath: IndexPath) {
        let apiManager = APIManager()
        
        apiManager.fetchGeminiContent(prompt: note.name ?? "") { [weak self] result in
            switch result {
            case .success(let brief):
                DispatchQueue.main.async {
                   
                    note.brief = brief
                    do {
                        try self?.context.save()
                        
                        if let visibleIndexPath = self?.tableView.indexPathsForVisibleRows?.contains(indexPath), visibleIndexPath == true {
                            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                    } catch {
                        print("Error saving brief to Core Data: \(error)")
                    }
                }
            case .failure(let error):
                print("Error fetching brief from API: \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

