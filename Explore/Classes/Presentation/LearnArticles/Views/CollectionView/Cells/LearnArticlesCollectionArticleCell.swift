//
//  LearnArticlesCollectionArticleCell.swift
//  Explore
//
//  Created by Andrey Chernyshev on 22.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class LearnArticlesCollectionArticleCell: UICollectionViewCell {
    weak var actionsDelegate: LearnArticlesCollectionViewDelegate?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var thumbImageView = makeThumbImageView()
    lazy var separatorView = makeSeparatorView()
    
    private var article: LearnArticle!
    
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

extension LearnArticlesCollectionArticleCell {
    func setup(article: LearnArticle) {
        self.article = article
        
        if let url = URL(string: article.thumbUrl) {
            thumbImageView.kf.setImage(with: url)
        }
        
        titleLabel.text = article.name
    }
}

// MARK: Private

private extension LearnArticlesCollectionArticleCell {
    @objc
    func tapped() {
        actionsDelegate?.learnArticlesCollectionViewDidSelect(article: article)
    }
}

// MARK: Make constraints

private extension LearnArticlesCollectionArticleCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -106.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            thumbImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.scale),
            thumbImageView.widthAnchor.constraint(equalToConstant: 72.scale),
            thumbImageView.heightAnchor.constraint(equalToConstant: 72.scale)
        ])
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.scale),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.scale),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension LearnArticlesCollectionArticleCell {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.SFProText.bold(size: 22.scale)
        view.textColor = UIColor.black
        view.numberOfLines = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeThumbImageView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true 
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeSeparatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
