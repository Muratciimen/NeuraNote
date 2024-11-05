//
//  DatePickerViewController.swift
//  ToDoList
//
//  Created by Murat Çimen on 4.11.2024.
//

import UIKit

class DatePickerViewController: UIViewController {
    
    let datePicker = UIDatePicker()
    let selectButton = UIButton()
    let cancelButton = UIButton()
    
    var onDateSelected: ((Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 16
        
        setupDatePicker()
        setupButtons()
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        view.addSubview(datePicker)
        
        datePicker.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(200)
        }
    }
    
    private func setupButtons() {
        selectButton.setTitle("Select", for: .normal)
        selectButton.backgroundColor = .systemBlue
        selectButton.addTarget(self, action: #selector(didTapSelect), for: .touchUpInside)
        view.addSubview(selectButton)
        
        selectButton.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = .lightGray
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(selectButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
    }
    
    @objc private func didTapSelect() {
        onDateSelected?(datePicker.date)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
}
