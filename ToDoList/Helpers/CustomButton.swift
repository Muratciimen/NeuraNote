//
//  CustomButton.swift
//  ToDoList
//
//  Created by Murat Çimen on 1.11.2024.
//

import UIKit
import SnapKit

class CustomButton: UIButton {
    
    private let dashedBorder = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
       
        self.backgroundColor = UIColor(red: 1.0, green: 0.98, blue: 0.93, alpha: 1.0)
        self.layer.cornerRadius = 16
        
       
        dashedBorder.strokeColor = UIColor(red: 0.98, green: 0.68, blue: 0.4, alpha: 1.0).cgColor
        dashedBorder.lineDashPattern = [10, 8]
        dashedBorder.fillColor = nil
        dashedBorder.lineWidth = 1
        self.layer.addSublayer(dashedBorder)
        
        
        let plusLabel = UILabel()
        plusLabel.text = "+"
        plusLabel.textColor = UIColor(red: 0.98, green: 0.68, blue: 0.4, alpha: 1.0)
        plusLabel.font = UIFont.systemFont(ofSize: 32, weight: .light)
        plusLabel.textAlignment = .center
        
        self.addSubview(plusLabel)
        plusLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashedBorder.frame = self.bounds
        dashedBorder.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 16).cgPath
    }
}

//let screenWidth = UIScreen.main.bounds.width
//let plusIcon = UIImageView()
//plusIcon.image = UIImage(named: "plus1")
//self.addSubview(plusIcon)
//
//plusIcon.snp.makeConstraints { make in
//    make.top.equalToSuperview().offset(16)
//    make.left.equalToSuperview().offset(screenWidth * 0.3)
//    make.height.equalTo(28)
//    make.width.equalTo(28)
//}
//
//let addList = UILabel()
//addList.text = "Add List"
//addList.textColor = UIColor(red: 0.98, green: 0.68, blue: 0.4, alpha: 1.0)
//addList.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//
//self.addSubview(addList)
//addList.snp.makeConstraints { make in
//    make.top.equalTo(20)
//    make.left.equalTo(plusIcon.snp.right).offset(4)
//}
//}
