//
//  FPWhatItIsCell.swift
//  Explore
//
//  Created by Andrey Chernyshev on 01.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class FPWhatItIsCell: UITableViewCell {
    lazy var messageLabel = makeMessageLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

private extension FPWhatItIsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32.scale),
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension FPWhatItIsCell {
    func makeMessageLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.SFProText.bold(size: 22.scale)
        view.textColor = UIColor.white
        view.numberOfLines = 0
        view.textAlignment = .left
        view.text = "FindPlace.FPWhatItIsCell.Message".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
