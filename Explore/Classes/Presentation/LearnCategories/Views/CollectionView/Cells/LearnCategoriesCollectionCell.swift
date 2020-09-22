//
//  LearnCategoriesCollectionCell.swift
//  Explore
//
//  Created by Andrey Chernyshev on 22.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class LearnCategoriesCollectionCell: UICollectionViewCell {
    weak var actionsDelegate: LearnCollectionViewDelegate?
    
    lazy var thumbImageView = makeThumbImageView()
    lazy var titleLabel = makeTitleLabel()

    private var category: LearnCategory!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.white
        
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

extension LearnCategoriesCollectionCell {
    func setup(category: LearnCategory) {
        self.category = category
        
        if let url = URL(string: category.thumbUrl) {
            thumbImageView.kf.setImage(with: url)
        }
        
        titleLabel.attributedText = category.name.attributed(with: TextAttributes()
            .textColor(UIColor.white)
            .font(Font.SFProText.bold(size: 18.scale))
            .lineHeight(18.scale)
            .textAlignment(.center)
            .letterSpacing(-0.025.scale))
    }
}

// MARK: Private

private extension LearnCategoriesCollectionCell {
    @objc
    func tapped() {
        actionsDelegate?.learnCollectionViewDidSelect(category: category)
    }
}

// MARK: Make constraints

private extension LearnCategoriesCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            thumbImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.scale),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension LearnCategoriesCollectionCell {
    func makeThumbImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        
        return view 
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
