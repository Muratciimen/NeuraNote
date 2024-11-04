//
//  BriefCell.swift
//  ToDoList
//
//  Created by Murat Çimen on 25.10.2024.
//

import UIKit
import SnapKit

class BriefCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(hex: "#DBDBDB")
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#4a4949")
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    let briefLabel: UILabel = {
        let briefLabel = UILabel()
        briefLabel.textColor = UIColor(hex: "#4a4949")
        briefLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        briefLabel.numberOfLines = 0
        briefLabel.sizeToFit()
        return briefLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(briefLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        briefLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configureCell(title: String, brief: String, isChecked: Bool) {
        let attributedString = NSMutableAttributedString(string: title)
        
        if isChecked {
            attributedString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributedString.length))
        } else {
            attributedString.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, attributedString.length))
        }
        
        titleLabel.attributedText = attributedString
        briefLabel.text = brief
    }
}
