//
//  WallpapersView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 16.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class WallpapersView: UIView {
    lazy var collectionView = makeCollectionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.black
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

private extension WallpapersView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension WallpapersView {
    func makeCollectionView() -> WallpapersCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8.scale
        
        let view = WallpapersCollectionView(frame: .zero, collectionViewLayout: layout)
        view.contentInset = UIEdgeInsets(top: 0.scale, left: 15.scale, bottom: ScreenSize.isIphoneXFamily ? 40.scale : 15.scale, right: 15.scale)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
