//
//  CalenderVC.swift
//  ToDoList
//
//  Created by Murat Çimen on 1.11.2024.
//

import UIKit
import SnapKit

class CalenderVC: UIViewController {
    
     let calenderTitleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(hex: "F9F9F9")
        
        calenderTitleLabel.text = "Calender"
        calenderTitleLabel.textAlignment = .center
        calenderTitleLabel.textColor = UIColor(hex: "#484848")
        calenderTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        view.addSubview(calenderTitleLabel)

        calenderTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).multipliedBy(0.1)
            make.centerX.equalToSuperview()
        }
    }
}
