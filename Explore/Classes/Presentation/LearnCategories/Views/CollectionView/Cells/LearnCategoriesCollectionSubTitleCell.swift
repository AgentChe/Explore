//
//  LearnCategoriesCollectionSubTitleCell.swift
//  Explore
//
//  Created by Andrey Chernyshev on 22.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class LearnCategoriesCollectionSubTitleCell: UICollectionViewCell {
    lazy var subTitleLabel = makeSubTitleLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.white
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

private extension LearnCategoriesCollectionSubTitleCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension LearnCategoriesCollectionSubTitleCell {
    func makeSubTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.SFProText.regular(size: 17.scale)
        view.textColor = UIColor.black
        view.text = "LearnCategories.SubTitle".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
