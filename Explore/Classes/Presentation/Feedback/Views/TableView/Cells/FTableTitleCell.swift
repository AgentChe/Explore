//
//  FTableTitleCell.swift
//  Explore
//
//  Created by Andrey Chernyshev on 13.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class FTableTitleCell: UITableViewCell {
    lazy var titleLabel = makeTitleLabel()
    lazy var textField = makeTextField()
    
    private var element: FTableElement!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension FTableTitleCell {
    func setup(element: FTableElement) {
        self.element = element
        
        textField.text = element.title
    }
}

// MARK: Private
private extension FTableTitleCell {
    func configure() {
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
    
    @objc
    func textFieldDidChanged() {
        element.title = textField.text
    }
}

// MARK: Make constraints
private extension FTableTitleCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension FTableTitleCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Font.Poppins.regular(size: 14.scale))
            .lineHeight(21.scale)
            .letterSpacing(0.5.scale)
        
        let view = UILabel()
        view.attributedText = "Feedback.TitleCell.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTextField() -> PaddingTextField {
        let view = PaddingTextField()
        view.leftInset = 16.scale
        view.rightInset = 16.scale
        view.layer.cornerRadius = 5.scale
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = UIColor(red: 235 / 255, green: 240 / 255, blue: 1, alpha: 1).cgColor
        view.backgroundColor = UIColor.clear
        view.font = Font.Poppins.regular(size: 12.scale)
        view.textColor = UIColor.white
        view.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
