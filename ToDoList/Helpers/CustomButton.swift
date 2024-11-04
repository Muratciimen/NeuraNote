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

