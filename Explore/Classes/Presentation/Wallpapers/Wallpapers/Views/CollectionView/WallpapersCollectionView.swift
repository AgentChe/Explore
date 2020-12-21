//
//  WallpapersCollectionView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 16.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class WallpapersCollectionView: UICollectionView {
    fileprivate let didSelectWallpaper = PublishRelay<Wallpaper>()
    
    private var elements = [WallpaperCollectionElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        register(WallpaperCollectionCell.self, forCellWithReuseIdentifier: String(describing: WallpaperCollectionCell.self))
        register(WallpapersCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: WallpapersCollectionHeader.self))
        
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API

extension WallpapersCollectionView {
    func setup(elements: [WallpaperCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource

extension WallpapersCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let wallpaper = elements[indexPath.row].wallpaper
        
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WallpaperCollectionCell.self), for: indexPath) as! WallpaperCollectionCell
        cell.setup(thumbUrl: wallpaper.thumbUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                    withReuseIdentifier: String(describing: WallpapersCollectionHeader.self),
                                                    for: indexPath)
        default:
            fatalError("WallpapersCollectionView unexpected element kind")
        }
    }
}

// MARK: UICollectionViewDelegate

extension WallpapersCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 105.scale, height: 194.scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: frame.size.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let wallpaper = elements[indexPath.row].wallpaper
        didSelectWallpaper.accept(wallpaper)
    }
}

// MARK: Rx

extension Reactive where Base: WallpapersCollectionView {
    var didSelectWallpaper: Signal<Wallpaper> {
        base.didSelectWallpaper.asSignal()
    }
}
