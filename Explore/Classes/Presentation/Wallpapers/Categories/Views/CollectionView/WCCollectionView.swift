//
//  WCCollectionView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 21.12.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class WCCollectionView: UICollectionView {
    var didSelect: ((Int) -> Void)?
    
    private var sections = [WCCollectionSection]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension WCCollectionView {
    func setup(sections: [WCCollectionSection]) {
        self.sections = sections
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension WCCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
        case .newArrivals:
            return 1
        case .categories(let categories):
            return categories.elements.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        
        switch section {
        case .newArrivals(let newArrivals):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WCCollectionNewArrivalsCell.self), for: indexPath) as! WCCollectionNewArrivalsCell
            cell.collectionView.setup(elements: newArrivals.elements)
            cell.collectionView.didSelect = { [weak self] id in
                self?.didSelect?(id.categoryId)
            }
            return cell
        case .categories(let categories):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WCCollectionCell.self), for: indexPath) as! WCCollectionCell
            cell.setup(element: categories.elements[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header =  dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                           withReuseIdentifier: String(describing: WCCollectionHeader.self),
                                                           for: indexPath) as! WCCollectionHeader
            
            switch sections[indexPath.section] {
            case .newArrivals(let section), .categories(let section):
                header.titleLabel.attributedText = section.title
                    .attributed(with: TextAttributes()
                                    .textColor(UIColor.white)
                                    .font(Font.Poppins.regular(size: 24.scale)))
            }
            
            return header
        default:
            fatalError("WallpapersCollectionView unexpected element kind")
        }
    }
}

// MARK: UICollectionViewDelegate
extension WCCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch sections[indexPath.section] {
        case .newArrivals:
            return CGSize(width: 343.scale, height: 171.scale)
        case .categories:
            return CGSize(width: 343.scale, height: 164.scale)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: 375.scale, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .categories(let section):
            let id = section.elements[indexPath.row].categoryId
            didSelect?(id)
        case .newArrivals:
            break
        }
    }
}

// MARK: Private
private extension WCCollectionView {
    func configure() {
        backgroundColor = UIColor.black
        
        register(WCCollectionCell.self, forCellWithReuseIdentifier: String(describing: WCCollectionCell.self))
        register(WCCollectionNewArrivalsCell.self, forCellWithReuseIdentifier: String(describing: WCCollectionNewArrivalsCell.self))
        register(WCCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: WCCollectionHeader.self))
        
        dataSource = self
        delegate = self
    }
}

