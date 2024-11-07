//
//  HomeCell.swift
//  ToDoList
//
//  Created by Murat Çimen on 1.11.2024.
//

import UIKit
import SnapKit

class HomeCell: UITableViewCell {
    
    let containerView = UIView() 
    let titleLabel = UILabel()
    let taskCountLabel = UILabel()
    let backgroundColorView = UIView()
    let iconImageView = UIImageView()
    let buttonImageView = UIImageView()
    let extraView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        containerView.addSubview(backgroundColorView)
        backgroundColorView.layer.cornerRadius = 10
        backgroundColorView.clipsToBounds = true
        
        backgroundColorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        iconImageView.image = UIImage(named: "whiteIcon")?.withRenderingMode(.alwaysTemplate)
        iconImageView.contentMode = .scaleAspectFit
        backgroundColorView.addSubview(iconImageView)
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(24)
        }

        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = UIColor(hex: "#545454")
        backgroundColorView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(iconImageView.snp.right).offset(16)
        }
        
        buttonImageView.image = UIImage(named: "right")
        buttonImageView.contentMode = .scaleAspectFit
        buttonImageView.isUserInteractionEnabled = true
        backgroundColorView.addSubview(buttonImageView)
        
        buttonImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(24)
        }
        
        extraView.backgroundColor = UIColor(hex: "#FFFFFF")
        extraView.layer.cornerRadius = 6
        extraView.alpha = 0.6
        backgroundColorView.addSubview(extraView)
        
        extraView.snp.makeConstraints { make in
            make.right.equalTo(buttonImageView.snp.left).offset(-11)
            make.centerY.equalTo(buttonImageView)
            make.width.equalTo(70)
            make.height.equalTo(24)
             
        }

        taskCountLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        taskCountLabel.textColor = UIColor(hex: "#8E8E90")
        extraView.addSubview(taskCountLabel)
        taskCountLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func iconColor(for backgroundColor: UIColor) -> UIColor {
        switch backgroundColor {
        case UIColor(hex: "#F0F6E0"):
            return UIColor(hex: "#A4BE68")
        case UIColor(hex: "#C9EFDC"):
            return UIColor(hex: "#7EAE96")
        case UIColor(hex: "#D7D5FF"):
            return UIColor(hex: "#8580E1")
        case UIColor(hex: "#C7DAFF"):
            return UIColor(hex: "#83A9EF")
        case UIColor(hex: "#EED7ED"):
            return UIColor(hex: "#CD6DC8")
        case UIColor(hex: "#F3D5D5"):
            return UIColor(hex: "#E36B6B")
        case UIColor(hex: "#FFDCB8"):
            return UIColor(hex: "#FF9F3E")
        default:
            return UIColor(hex: "#FFFFFF")
        }
    }
    
    func configure(title: String, taskCount: Int, color: UIColor) {
        titleLabel.text = title
        taskCountLabel.text = "\(taskCount) Task"
        backgroundColorView.backgroundColor = color
        iconImageView.tintColor = iconColor(for: color)
    }
    
}
