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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.clear
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = 13.scale
        contentView.layer.masksToBounds = true
        contentView.layer.borderColor = UIColor(red: 37 / 255, green: 37 / 255, blue: 37 / 255, alpha: 0.9).cgColor
        contentView.layer.borderWidth = 1.scale
        
        layer.cornerRadius = 13.scale
        layer.masksToBounds = false
        layer.borderColor = UIColor(red: 37 / 255, green: 37 / 255, blue: 37 / 255, alpha: 0.9).cgColor
        layer.borderWidth = 1.scale
    }
    
    func setup(iconName: String, title: String) {
        iconView.image = UIImage(named: iconName)
        
        titleLabel.attributedText = title.attributed(with: TextAttributes()
            .textColor(UIColor.white)
            .font(Font.Poppins.semibold(size: 13.scale))
            .lineHeight(23.scale)
            .letterSpacing(0.3.scale)
            .textAlignment(.center))
    }
}

// MARK: Make constraints
private extension DirectCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14.scale),
            iconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconView.heightAnchor.constraint(equalToConstant: 21.scale),
            iconView.widthAnchor.constraint(equalToConstant: 21.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.scale),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale)
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
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
