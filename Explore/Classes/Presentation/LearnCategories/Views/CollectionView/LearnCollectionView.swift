//
//  LearnCollectionView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 22.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class LearnCollectionView: UICollectionView {
    weak var actionsDelegate: LearnCollectionViewDelegate?
    
    private var elements = [LearnCategoriesCollectionElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API

extension LearnCollectionView {
    func setup(elements: [LearnCategoriesCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource

extension LearnCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch elements[indexPath.row] {
        case .title:
            return dequeueReusableCell(withReuseIdentifier: String(describing: LearnCategoriesCollectionTitleCell.self), for: indexPath)
        case .subTitle:
            return dequeueReusableCell(withReuseIdentifier: String(describing: LearnCategoriesCollectionSubTitleCell.self), for: indexPath)
        case .category(let category):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: LearnCategoriesCollectionCell.self), for: indexPath) as! LearnCategoriesCollectionCell
            cell.actionsDelegate = actionsDelegate
            cell.setup(category: category)
            return cell
        }
    }
}

// MARK: UICollectionViewDelegate

extension LearnCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            assertionFailure("Wrong layout type supplied")
            return .zero
        }

        let cellWidth = frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        
        switch elements[indexPath.row] {
        case .title:
            return CGSize(width: cellWidth, height: 41.scale)
        case .subTitle:
            return CGSize(width: cellWidth, height: 22.scale)
        case .category:
            return CGSize(width: 158.scale, height: 158.scale)
        }
    }
}

// MARK: Private

private extension LearnCollectionView {
    func setup() {
        backgroundColor = UIColor.clear
        
        register(LearnCategoriesCollectionTitleCell.self, forCellWithReuseIdentifier: String(describing: LearnCategoriesCollectionTitleCell.self))
        register(LearnCategoriesCollectionSubTitleCell.self, forCellWithReuseIdentifier: String(describing: LearnCategoriesCollectionSubTitleCell.self))
        register(LearnCategoriesCollectionCell.self, forCellWithReuseIdentifier: String(describing: LearnCategoriesCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
