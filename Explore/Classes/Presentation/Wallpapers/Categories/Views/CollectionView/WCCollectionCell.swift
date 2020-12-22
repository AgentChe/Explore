//
//  WCCollectionCell.swift
//  Explore
//
//  Created by Andrey Chernyshev on 21.12.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class WCCollectionCell: UICollectionViewCell {
    lazy var imageView = makeImageView()
    lazy var countLabel = makeLabel()
    lazy var nameLabel = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        imageView.kf.cancelDownloadTask()
    }
}

// MARK: API
extension WCCollectionCell {
    func setup(element: WCCollectionElement) {
        if let url = URL(string: element.imageUrl) {
            imageView.kf.setImage(with: url)
        }
        
        let count = String(format: "WallpapersCategories.CountWallpapers".localized, element.wallpapersCount)
        countLabel.attributedText = count
            .attributed(with: TextAttributes()
                            .textColor(UIColor.white.withAlphaComponent(0.7))
                            .font(Font.Poppins.regular(size: 12.scale))
                            .textAlignment(.center))
        
        nameLabel.attributedText = element.name
            .attributed(with: TextAttributes()
                            .textColor(UIColor.white)
                            .font(Font.Poppins.semibold(size: 18.scale))
                            .textAlignment(.center))
    }
}

// MARK: Private
private extension WCCollectionCell {
    func configure() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension WCCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            countLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            countLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WCCollectionCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 12.scale
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

