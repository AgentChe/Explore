//
//  NewArrivalsCollectionCell.swift
//  Explore
//
//  Created by Andrey Chernyshev on 21.12.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class NewArrivalsCollectionCell: UICollectionViewCell {
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
extension NewArrivalsCollectionCell {
    func setup(element: WCCollectionElement) {
        if let url = URL(string: element.imageUrl) {
            imageView.kf.setImage(with: url)
        }
        
        let count = String(format: "WallpapersCategories.CountWallpapers".localized, element.wallpapersCount)
        countLabel.attributedText = count
            .attributed(with: TextAttributes()
                            .textColor(UIColor.white.withAlphaComponent(0.7))
                            .font(Font.Poppins.regular(size: 12.scale))
                            .letterSpacing(-1.6.scale))
        
        nameLabel.attributedText = element.name
            .attributed(with: TextAttributes()
                            .textColor(UIColor.white)
                            .font(Font.Poppins.regular(size: 18.scale)))
    }
}

// MARK: Private
private extension NewArrivalsCollectionCell {
    func configure() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension NewArrivalsCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 128.scale),
            imageView.heightAnchor.constraint(equalToConstant: 128.scale),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            countLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            countLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -6.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension NewArrivalsCollectionCell {
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
