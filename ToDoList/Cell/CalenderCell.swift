//
//  CalenderCell.swift
//  ToDoList
//
//  Created by Murat Çimen on 13.11.2024.
//

//import UIKit
//import SnapKit
//
//class CalenderCell: UITableViewCell {
//    
//    var checkBoxTapped: (() -> Void)?
//    var buttonTappedAction: (() -> Void)?
//    let button = UIButton()
//
//    private let containerView: UIView = {
//        let view = UIView()
//        view.layer.cornerRadius = 10
//        view.backgroundColor = .yellow
//        view.layer.borderWidth = 0.5
//        view.layer.borderColor = UIColor(hex: "#DBDBDB").cgColor
//        return view
//    }()
//    
//    let checkBoxButton: UIButton = {
//        let button = UIButton()
//        let uncheckedImage = UIImage(named: "uncheck")?.withRenderingMode(.alwaysOriginal)
//        let checkedImage = UIImage(named: "check")?.withRenderingMode(.alwaysOriginal)
//        
//        if uncheckedImage == nil {
//            print("Unchecked image 'fill' not found!")
//        }
//
//        if checkedImage == nil {
//            print("Checked image 'unfill' not found!")
//        }
//        button.setImage(uncheckedImage, for: .normal)
//        button.setImage(checkedImage, for: .selected)
//        button.addTarget(self, action: #selector(checkBoxTappedAction), for: .touchUpInside)
//        return button
//    }()
//    
//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.backgroundColor = .red
//        label.textColor = UIColor(hex: "#4a4949")
//        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//        label.numberOfLines = 0
//        label.lineBreakMode = .byWordWrapping
//        label.sizeToFit()
//        return label
//    }()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupCell()
//        self.backgroundColor = .clear
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setupCell() {
//        contentView.addSubview(containerView)
//        containerView.addSubview(checkBoxButton)
//        containerView.addSubview(titleLabel)
//        containerView.addSubview(button)
//        
//        containerView.snp.makeConstraints { make in
//            make.edges.equalToSuperview().inset(10)
//        }
//        
//        checkBoxButton.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.left.equalToSuperview().offset(16)
//            make.width.height.equalTo(40)
//        }
//        
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(10)
//            make.left.equalTo(checkBoxButton.snp.right).offset(16)
//            make.right.equalTo(button.snp.left).offset(-16)
//            make.bottom.equalToSuperview().offset(-10)
//        }
//        
//        button.setImage(UIImage(named: "right"), for: .normal)
//        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
//        button.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.right.equalToSuperview().offset(-16)
//            make.width.height.equalTo(24)
//        }
//    }
//    
//    @objc func checkBoxTappedAction() {
//        checkBoxButton.isSelected.toggle()
//        checkBoxTapped?()
//    }
//    
//    func configureCell(title: String, isChecked: Bool) {
//   
//        let attributedString = NSMutableAttributedString(string: title)
//        
//        if isChecked {
//            attributedString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributedString.length))
//        } else {
//            attributedString.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, attributedString.length))
//        }
//        
//        titleLabel.attributedText = attributedString
//        checkBoxButton.isSelected = isChecked
//    }
//
//    
//    @objc private func buttonTapped() {
//        buttonTappedAction?()
//    }
//}
//

import UIKit
import SnapKit

class CalenderCell: UITableViewCell {
    
    var checkBoxTapped: (() -> Void)?
    var buttonTappedAction: (() -> Void)?
    let button = UIButton()

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .clear
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(hex: "#DBDBDB").cgColor
        return view
    }()
    
    let checkBoxButton: UIButton = {
        let button = UIButton()
        let uncheckedImage = UIImage(named: "uncheck")?.withRenderingMode(.alwaysOriginal)
        let checkedImage = UIImage(named: "check")?.withRenderingMode(.alwaysOriginal)
        
        if uncheckedImage == nil {
            print("Unchecked image 'fill' not found!")
        }

        if checkedImage == nil {
            print("Checked image 'unfill' not found!")
        }
        button.setImage(uncheckedImage, for: .normal)
        button.setImage(checkedImage, for: .selected)
        button.addTarget(self, action: #selector(checkBoxTappedAction), for: .touchUpInside)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#4a4949")
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell() {
        contentView.addSubview(containerView)
        containerView.addSubview(checkBoxButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(button)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        checkBoxButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(checkBoxButton.snp.right).offset(16)
            make.right.equalTo(button.snp.left).offset(-16)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        button.setImage(UIImage(named: "right"), for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(24)
        }
    }
    
    @objc func checkBoxTappedAction() {
        checkBoxButton.isSelected.toggle()
        checkBoxTapped?()
    }
    
    func configureCell(title: String, isChecked: Bool) {
   
        let attributedString = NSMutableAttributedString(string: title)
        
        if isChecked {
            attributedString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributedString.length))
        } else {
            attributedString.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, attributedString.length))
        }
        
        titleLabel.attributedText = attributedString
        checkBoxButton.isSelected = isChecked
    }

    
    @objc private func buttonTapped() {
        buttonTappedAction?()
    }
}
