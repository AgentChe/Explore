//
//  WallpaperCollectionCell.swift
//  Explore
//
//  Created by Andrey Chernyshev on 16.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import Kingfisher

final class WallpaperCollectionCell: UICollectionViewCell {
    lazy var thumbImageView = makeThumbImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.clear
        
        let clearSelectedView = UIView()
        clearSelectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = clearSelectedView
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbImageView.kf.cancelDownloadTask()
        thumbImageView.image = nil
    }
}

// MARK: API
extension WallpaperCollectionCell {
    func setup(thumbUrl: String) {
        if let url = URL(string: thumbUrl) {
            thumbImageView.kf.setImage(with: url)
        }
    }
}

// MARK: Make constraints
private extension WallpaperCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            thumbImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}


// MARK: Lazy initialization
private extension WallpaperCollectionCell {
    func makeThumbImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true 
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
