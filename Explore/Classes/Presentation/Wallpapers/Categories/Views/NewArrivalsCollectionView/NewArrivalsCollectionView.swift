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
    
    var section = WCCollectionSection.Section(title: "", elements: []) {
        didSet {
            reloadData()
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UICollectionViewDataSource
extension NewArrivalsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.section.elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: NewArrivalsCollectionCell.self), for: indexPath) as! NewArrivalsCollectionCell
        cell.setup(element: section.elements[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header =  dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                           withReuseIdentifier: String(describing: WCCollectionHeader.self),
                                                           for: indexPath) as! WCCollectionHeader
            header.titleLabel.attributedText = section.title
                .attributed(with: TextAttributes()
                                .textColor(UIColor.white)
                                .font(Font.Poppins.regular(size: 24.scale)))
        default:
            fatalError("WallpapersCollectionView unexpected element kind")
        }
    }
}

// MARK: UICollectionViewDelegate
extension NewArrivalsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 128.scale, height: 171.scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: frame.size.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelect?(section.elements[indexPath.row])
    }
}

// MARK: Private
private extension NewArrivalsCollectionView {
    func configure() {
        backgroundColor = UIColor.black
        
        dataSource = self
        delegate = self
        
        register(NewArrivalsCollectionCell.self, forCellWithReuseIdentifier: String(describing: NewArrivalsCollectionCell.self))
        register(WCCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: WCCollectionHeader.self))
    }
}
