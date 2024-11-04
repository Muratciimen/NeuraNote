//
//  CreateVC.swift
//  ToDoList
//
//  Created by Murat Çimen on 1.11.2024.
//

import UIKit
import SnapKit

protocol CreateVCDelegate: AnyObject {
    func didCreateTask(task: String, color: UIColor)
}

class CreateVC: UIViewController, UITextFieldDelegate {
    
    let listName = UILabel()
    let textField = UITextField()
    let colorName = UILabel()
    let colorPickerView = ColorPickerCollectionView()
    var createButton = UIButton()

    weak var delegate: CreateVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureNavigationBar()
        textField.delegate = self
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(hex: "F9F9F9")
        
        let headerView = CustomHeaderView(headerType: .toDoList)
        view.addSubview(headerView)
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).multipliedBy(0.1)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        listName.text = "List Name:"
        listName.textAlignment = .left
        listName.textColor = UIColor(hex: "#484848")
        listName.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        view.addSubview(listName)
        
        listName.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(15)
            make.left.equalTo(24)
        }
        
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor(hex: "#DADADA").cgColor
        textField.layer.cornerRadius = 15
        textField.textColor = UIColor(hex: "#484848")
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftView = paddingView
        textField.leftViewMode = .always;
        
        view.addSubview(textField)

        textField.snp.makeConstraints { make in
            make.top.equalTo(listName.snp.bottom).offset(12)
            make.left.equalTo(21)
            make.right.equalToSuperview().inset(21)
            make.height.equalTo(50)
        }
        
        colorName.text = "Color:"
        colorName.textAlignment = .left
        colorName.textColor = UIColor(hex: "#484848")
        colorName.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        view.addSubview(colorName)
        
        colorName.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(28)
            make.left.equalTo(24)
        }
        
        colorPickerView.colors = [
            UIColor(hex: "#FFDCB8"),
            UIColor(hex: "#F3D5D5"),
            UIColor(hex: "#EED7ED"),
            UIColor(hex: "#C7DAFF"),
            UIColor(hex: "#D7D5FF"),
            UIColor(hex: "#F0F6E0"),
            UIColor(hex: "#C9EFDC")
        ]
        
        colorPickerView.colorSelected = { [weak self] selectedColor in
            print("Seçilen renk: \(selectedColor)")
            self?.updateCreateButtonState()
        }
        
        view.addSubview(colorPickerView)
        colorPickerView.snp.makeConstraints { make in
            make.top.equalTo(colorName.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(21)
            make.height.equalTo(60)
        }
                
        createButton = UIButton.createCustomButton(of: .create, target: self, action: #selector(createButtonTapped))
        view.addSubview(createButton)
        
        createButton.snp.makeConstraints { make in
            make.top.equalTo(colorPickerView.snp.bottom).offset(24)
            make.left.equalTo(24)
            make.right.equalTo(-24)
            make.height.equalTo(56)
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateCreateButtonState()
    }

    private func updateCreateButtonState() {
        if let text = textField.text, !text.isEmpty, colorPickerView.selectedIndexPath != nil {
            createButton.backgroundColor = UIColor(hex: "#FFAF5F")
            createButton.isUserInteractionEnabled = true
        } else {
            createButton.backgroundColor = UIColor(hex: "#FFE1C3")
            createButton.isUserInteractionEnabled = false
        }
    }

    @objc private func createButtonTapped() {
        guard let listNameText = textField.text, !listNameText.isEmpty else {
            return
        }

        guard let selectedIndexPath = colorPickerView.selectedIndexPath else {
            let defaultColor = UIColor.gray
            delegate?.didCreateTask(task: listNameText, color: defaultColor)

            let taskVC = TaskVC()
            taskVC.taskTitle = listNameText
            navigationController?.pushViewController(taskVC, animated: true)
            return
        }

        let selectedColor = colorPickerView.colors[selectedIndexPath.row]
        delegate?.didCreateTask(task: listNameText, color: selectedColor)

        let taskVC = TaskVC()
        taskVC.taskTitle = listNameText 
        navigationController?.pushViewController(taskVC, animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 17
    }


    func configureNavigationBar() {
        navigationItem.title = ""
        navigationItem.hidesBackButton = true
    }
}
