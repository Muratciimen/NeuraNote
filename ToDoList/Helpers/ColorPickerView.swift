//
//  ColorPickerView.swift
//  ToDoList
//
//  Created by Murat Çimen on 1.11.2024.
//

import UIKit

class ColorPickerView: UIView {
    
    var colors: [UIColor] = []
    var colorSelected: ((UIColor) -> Void)?
    
    init(colors: [UIColor]) {
        self.colors = colors
        super.init(frame: .zero)
        setupColors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupColors() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        for color in colors {
            let button = UIButton()
            button.backgroundColor = color
            button.layer.cornerRadius = 30
            button.layer.borderWidth = 3
            button.layer.borderColor = UIColor.clear.cgColor
            button.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
            button.tag = colors.firstIndex(of: color) ?? 0
            
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc private func colorButtonTapped(_ sender: UIButton) {
        
        let selectedColor = colors[sender.tag]
        colorSelected?(selectedColor)
        
      
        for subview in subviews.first?.subviews ?? [] {
            if let button = subview as? UIButton {
                button.layer.borderColor = UIColor.clear.cgColor
            }
        }
        
        sender.layer.borderColor = UIColor(hex: "#FFAF5F").cgColor
    }
}
