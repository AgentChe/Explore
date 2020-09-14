//
//  DirectCollectionCell.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class DirectCollectionCell: UICollectionViewCell {
    lazy var iconView = makeIconView()
    lazy var titleLabel = makeLabel()
    lazy var subTitleLabel = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor(red: 37 / 255, green: 37 / 255, blue: 37 / 255, alpha: 0.6)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = 13.scale
        contentView.layer.masksToBounds = true
        
        layer.cornerRadius = 13.scale
        layer.masksToBounds = false
    }
    
    func setup(iconName: String, title: String, subTitle: String) {
        iconView.image = UIImage(named: iconName)
        
        titleLabel.attributedText = title.attributed(with: TextAttributes()
            .textColor(UIColor.white)
            .font(Font.SFProText.bold(size: 22.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.03.scale))
        
        subTitleLabel.attributedText = subTitle.attributed(with: TextAttributes()
            .textColor(UIColor.white)
            .font(Font.SFProText.regular(size: 15.scale))
            .lineHeight(17.scale)
            .letterSpacing(-0.24.scale))
    }
}

// MARK: Make constraints

private extension DirectCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.scale),
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6.scale),
            iconView.heightAnchor.constraint(equalToConstant: 32.scale),
            iconView.widthAnchor.constraint(equalToConstant: 67.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.scale),
            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension DirectCollectionCell {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
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
