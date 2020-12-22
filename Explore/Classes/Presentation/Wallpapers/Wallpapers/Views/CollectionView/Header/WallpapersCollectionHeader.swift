//
//  WallpapersCollectionHeader.swift
//  Explore
//
//  Created by Andrey Chernyshev on 16.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class WallpapersCollectionHeader: UICollectionReusableView {
    lazy var titleLabel = makeTitleLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

private extension WallpapersCollectionHeader {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension WallpapersCollectionHeader {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor(red: 221 / 255, green: 221 / 255, blue: 221 / 255, alpha: 1)
        view.font = Font.SFProText.bold(size: 34.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
