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
    
    private var sections = [DirectCollectionSection]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        dataSource = self
        delegate = self
        
        register(DirectCollectionCell.self, forCellWithReuseIdentifier: String(describing: DirectCollectionCell.self))
        register(DirectCollectionTermsOfServiceCell.self, forCellWithReuseIdentifier: String(describing: DirectCollectionTermsOfServiceCell.self))
        register(DirectCollectionDotsCell.self, forCellWithReuseIdentifier: String(describing: DirectCollectionDotsCell.self))
        register(DirectCollectionExploreCell.self, forCellWithReuseIdentifier: String(describing: DirectCollectionExploreCell.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension DirectCollectionView {
    func setup(sections: [DirectCollectionSection]) {
        self.sections = sections
    }
}

// MARK: UICollectionViewDataSource
extension DirectCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        let element = section.elements[indexPath.row]
        
        switch element {
        case .explore(let model):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: DirectCollectionExploreCell.self), for: indexPath) as! DirectCollectionExploreCell
            cell.setup(title: model.title, subTitle: model.subTitle)
            return cell 
        case .learn(let model), .wallpapers(let model), .join(let model), .journal(let model):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: DirectCollectionCell.self), for: indexPath) as! DirectCollectionCell
            cell.setup(iconName: model.iconName,
                       title: model.title)
            return cell
        case .termsOfService:
            return dequeueReusableCell(withReuseIdentifier: String(describing: DirectCollectionTermsOfServiceCell.self), for: indexPath)
        case .dots:
            return dequeueReusableCell(withReuseIdentifier: String(describing: DirectCollectionDotsCell.self), for: indexPath)
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension DirectCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: 0, left: 24.scale, bottom: 0, right: 24.scale)
        case 1:
            return UIEdgeInsets(top: 18, left: 24.scale, bottom: 0, right: 24.scale)
        case 2:
            return UIEdgeInsets(top: 18.scale, left: 48.scale, bottom: 0, right: 48.scale)
        case 3:
            return UIEdgeInsets(top: 24.scale, left: 24.scale, bottom: 0, right: 24.scale)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = sections[indexPath.section]
        let element = section.elements[indexPath.row]
        
        switch element {
        case .explore:
            return CGSize(width: 327.scale, height: 107.scale)
        case .learn, .wallpapers, .join, .journal:
            return CGSize(width: 127.scale, height: 79.scale)
        case .termsOfService:
            return CGSize(width: 335.scale, height: 40.scale)
        case .dots:
            return CGSize(width: 335.scale, height: 12.scale)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let element = section.elements[indexPath.row]
        
        didSelectElement.accept(element)
    }
}

// MARK: Rx
extension Reactive where Base: DirectCollectionView {
    var didSelectElement: Signal<DirectCollectionElement> {
        base.didSelectElement.asSignal()
    }
}
