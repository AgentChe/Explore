//
//  LearnContentCollectionTitleCell.swift
//  Explore
//
//  Created by Andrey Chernyshev on 22.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class LearnContentTableTitleCell: UITableViewCell {
    weak var delegate: LearnContentTableViewDelegate?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var articleNameLabel = makeArticleNameLabel()
    lazy var closeButton = makeCloseButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.white
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API

extension LearnContentTableTitleCell {
    func setup(articleName: String) {
        articleNameLabel.text = articleName
    }
}

// MARK: Private

private extension LearnContentTableTitleCell {
    @objc
    func tapped() {
        delegate?.learnContentTableViewDidCloseTapped()
    }
}

// MARK: Make constraints

private extension LearnContentTableTitleCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 44.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 44.scale),
            closeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -77.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            articleNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.scale),
            articleNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -77.scale),
            articleNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 9.scale),
            articleNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension LearnContentTableTitleCell {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor.black.withAlphaComponent(0.7)
        view.font = Font.SFProText.regular(size: 15.scale)
        view.text = "LearnContent.Title".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeArticleNameLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor.black
        view.font = Font.Poppins.regular(size: 26.scale)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeCloseButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Learn.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        
        view.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        return view
    }
}
