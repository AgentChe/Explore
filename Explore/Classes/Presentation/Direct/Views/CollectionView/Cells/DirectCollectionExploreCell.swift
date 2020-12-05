//
//  DirectCollectionExploreCell.swift
//  Explore
//
//  Created by Andrey Chernyshev on 05.12.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class DirectCollectionExploreCell: UICollectionViewCell {
    lazy var containerView = makeBackgroundView()
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeLabel()
    lazy var subTitleLabel = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension DirectCollectionExploreCell {
    func setup(title: String, subTitle: String) {
        titleLabel.attributedText = title
            .attributed(with: TextAttributes()
                            .textColor(UIColor.white)
                            .font(Font.Poppins.bold(size: 20.scale))
                            .lineHeight(28.scale)
                            .letterSpacing(0.3.scale)
                            .textAlignment(.center))
        
        subTitleLabel.attributedText = subTitle
            .attributed(with: TextAttributes()
                            .textColor(UIColor.white.withAlphaComponent(0.5))
                            .font(Font.Poppins.regular(size: 13.scale))
                            .lineHeight(20.scale)
                            .letterSpacing(-0.24.scale)
                            .textAlignment(.center))
    }
}

// MARK: Make constraints
private extension DirectCollectionExploreCell {
    func configure() {
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension DirectCollectionExploreCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 28.scale),
            imageView.heightAnchor.constraint(equalToConstant: 28.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 27.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            subTitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension DirectCollectionExploreCell {
    func makeBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(red: 153 / 255, green: 119 / 255, blue: 173 / 255, alpha: 1)
        view.layer.cornerRadius = 24.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Direct.Explore")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
