//
//  TextVC.swift
//  ToDoList
//
//  Created by Murat Çimen on 17.10.2024.
//

import UIKit
import UserNotifications
import SnapKit

class TextVC: UIViewController, UITextViewDelegate {
    
    let textView = UITextView()
    let selectDateButton = UIButton(type: .system)
    let saveButton = UIButton(type: .system)
    let cancelButton = UIButton(type: .system)
    
    var selectedDate: Date?
    var onSave: ((_ name: String, _ dueDate: Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#EEEEEE")
        setupUI()
        textView.delegate = self
        requestNotificationPermission()
        
        updateSaveButtonState()
    }
    
    func setupUI(){
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.cornerRadius = 8
        view.addSubview(textView)
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(350)
        }
        
        selectDateButton.setTitle("Select Date", for: .normal)
        selectDateButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        selectDateButton.backgroundColor = UIColor(hex: "#DBDBDB")
        selectDateButton.setTitleColor(.black, for: .normal)
        selectDateButton.layer.cornerRadius = 8
        selectDateButton.addTarget(self, action: #selector(didTapSelectDateButton), for: .touchUpInside)
        
        view.addSubview(selectDateButton)
        
        selectDateButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(20)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(50)
        }
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        saveButton.backgroundColor = UIColor(hex: "#DBDBDB")
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.layer.cornerRadius = 8
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        view.addSubview(saveButton)
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(selectDateButton.snp.bottom).offset(20)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(50)
        }
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cancelButton.backgroundColor = UIColor(hex: "#DBDBDB")
        cancelButton.setTitleColor(.red, for: .normal)
        cancelButton.layer.cornerRadius = 8
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom).offset(20)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
    
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
    
    func scheduleNotification(at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Don't forget your task!"
        content.sound = .default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled for \(date)")
            }
        }
    }
    
    @objc func didTapSaveButton() {
        guard let text = textView.text, !text.isEmpty else {
            print("Text is empty")
            return
        }
        
        guard let dueDate = selectedDate else {
            print("Date not selected")
            return
        }
        
        scheduleNotification(at: dueDate)
        
        onSave?(text, dueDate)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapSelectDateButton() {
        let alert = UIAlertController(title: "Select Due Date", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = UIColor.red
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.frame = CGRect(x: 0, y: 40, width: alert.view.bounds.width, height: 200)
        
       
        datePicker.minimumDate = Date()
        
        alert.view.addSubview(datePicker)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] _ in
            self?.selectedDate = datePicker.date
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            let dateString = formatter.string(from: datePicker.date)
            self?.selectDateButton.setTitle(dateString, for: .normal)
            self?.updateSaveButtonState()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {
        if let text = textView.text, !text.isEmpty {
            saveButton.isEnabled = true
            saveButton.backgroundColor = UIColor.systemBlue
        } else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = UIColor(hex: "#DBDBDB")
        }
    }
}
