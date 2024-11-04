//
//  ColorPickerCollectionView.swift
//  ToDoList
//
//  Created by Murat Çimen on 1.11.2024.
//

import UIKit
import SnapKit

class ColorPickerCollectionView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private var collectionView: UICollectionView!
    var colors: [UIColor] = []
    var colorSelected: ((UIColor) -> Void)?
    var selectedIndexPath: IndexPath?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: "ColorCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as? ColorCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: colors[indexPath.item])
        cell.isSelected = (indexPath == selectedIndexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let previousIndexPath = selectedIndexPath {
           
            collectionView.deselectItem(at: previousIndexPath, animated: false)
            if let previousCell = collectionView.cellForItem(at: previousIndexPath) as? ColorCell {
                previousCell.isSelected = false
            }
        }

        
        selectedIndexPath = indexPath
        let selectedColor = colors[indexPath.item]
        colorSelected?(selectedColor)

        
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? ColorCell {
            selectedCell.isSelected = true
        }
    }

   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
}

class ColorCell: UICollectionViewCell {
    private let colorView = UIView()

    override var isSelected: Bool {
        didSet {
           
            colorView.layer.borderColor = isSelected ? UIColor.orange.cgColor : UIColor.clear.cgColor
            colorView.layer.borderWidth = isSelected ? 3 : 0
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        colorView.layer.cornerRadius = 25 
        colorView.layer.masksToBounds = true
        addSubview(colorView)
        colorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(with color: UIColor) {
        colorView.backgroundColor = color
    }
}
