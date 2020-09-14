//
//  DirectCollectionView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 14.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class DirectCollectionView: UICollectionView {
    fileprivate let didSelectElement = PublishRelay<DirectCollectionElement>()
    
    private var elements = [DirectCollectionElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        dataSource = self
        delegate = self
        
        register(DirectCollectionCell.self, forCellWithReuseIdentifier: String(describing: DirectCollectionCell.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API

extension DirectCollectionView {
    func setup(elements: [DirectCollectionElement]) {
        self.elements = elements
    }
}

// MARK: UICollectionViewDataSource
 
extension DirectCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch elements[indexPath.row] {
        case .explore(let model), .learn(let model), .wallpapers(let model):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: DirectCollectionCell.self), for: indexPath) as! DirectCollectionCell
            cell.setup(iconName: model.iconName,
                       title: model.title,
                       subTitle: model.subTitle)
            return cell
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
 
extension DirectCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch elements[indexPath.row] {
        case .explore:
            return CGSize(width: 335.scale, height: 122.scale)
        case .learn, .wallpapers:
            return CGSize(width: 161.scale, height: 122.scale)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectElement.accept(elements[indexPath.row])
    }
}

// MARK: Rx

extension Reactive where Base: DirectCollectionView {
    var didSelectElement: Signal<DirectCollectionElement> {
        base.didSelectElement.asSignal()
    }
}
