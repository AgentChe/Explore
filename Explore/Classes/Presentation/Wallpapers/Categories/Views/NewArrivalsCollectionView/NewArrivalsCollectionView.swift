//
//  NewArrivalsCollectionView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 21.12.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class NewArrivalsCollectionView: UICollectionView {
    var didSelect: ((WCCollectionElement) -> Void)?
    
    private var elements = [WCCollectionElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension NewArrivalsCollectionView {
    func setup(elements: [WCCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension NewArrivalsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: NewArrivalsCollectionCell.self), for: indexPath) as! NewArrivalsCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension NewArrivalsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 128.scale, height: 171.scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelect?(elements[indexPath.row])
    }
}

// MARK: Private
private extension NewArrivalsCollectionView {
    func configure() {
        backgroundColor = UIColor.black
        
        dataSource = self
        delegate = self
        
        register(NewArrivalsCollectionCell.self, forCellWithReuseIdentifier: String(describing: NewArrivalsCollectionCell.self))
    }
}
