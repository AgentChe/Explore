//
//  FTableDescriptionCell.swift
//  Explore
//
//  Created by Andrey Chernyshev on 14.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class FTableDescriptionCell: UITableViewCell {
    lazy var titleLabel = makeTitleLabel()
    lazy var textView = makeTextView()
    
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
extension FTableDescriptionCell {
    func setup(element: FTableElement) {
        self.element = element
        
        textView.text = element.description
    }
}

// MARK: UITextViewDelegate
extension FTableDescriptionCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        element.description = textView.text
    }
}

// MARK: Private
private extension FTableDescriptionCell {
    func configure() {
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension FTableDescriptionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.scale),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textView.heightAnchor.constraint(equalToConstant: 160.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension FTableDescriptionCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Font.Poppins.regular(size: 14.scale))
            .lineHeight(21.scale)
            .letterSpacing(0.5.scale)
        
        let view = UILabel()
        view.attributedText = "Feedback.DescriptionCell.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTextView() -> UITextView {
        let view = UITextView()
        view.textColor = UIColor.white
        view.layer.cornerRadius = 5.scale
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = UIColor(red: 235 / 255, green: 240 / 255, blue: 1, alpha: 1).cgColor
        view.backgroundColor = UIColor.clear
        view.font = Font.Poppins.regular(size: 12.scale)
        view.textContainerInset = UIEdgeInsets(top: 16.scale, left: 16.scale, bottom: 16.scale, right: 16.scale)
        view.delegate = self 
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
