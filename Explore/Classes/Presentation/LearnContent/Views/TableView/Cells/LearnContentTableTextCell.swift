//
//  LearnContentCollectionTextCell.swift
//  Explore
//
//  Created by Andrey Chernyshev on 22.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class LearnContentTableTextCell: UITableViewCell {
    lazy var label = makeTextLabel()
    
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

extension LearnContentTableTextCell {
    func setup(text: String) {
        label.attributedText = text.attributed(with: TextAttributes()
            .textColor( UIColor(red: 131 / 255, green: 131 / 255, blue: 135 / 255, alpha: 1))
            .font(Font.SFProText.regular(size: 20.scale))
            .lineHeight(24.scale)
            .textAlignment(.center)
            .letterSpacing(0.015.scale))
    }
}

// MARK: Make constraints

private extension LearnContentTableTextCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension LearnContentTableTextCell {
    func makeTextLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
