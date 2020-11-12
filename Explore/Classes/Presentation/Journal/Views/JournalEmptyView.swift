//
//  JournalEmptyView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 11.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class JournalEmptyView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var imageView = makeImageView()
    lazy var bottomLabel = makeBottomLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension JournalEmptyView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -17.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 223.scale),
            imageView.heightAnchor.constraint(equalToConstant: 196.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 308.scale)
        ])
        
        NSLayoutConstraint.activate([
            bottomLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            bottomLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            bottomLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 21.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension JournalEmptyView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Font.Poppins.bold(size: 18.scale))
            .textAlignment(.center)
            .lineHeight(27.scale)
            .letterSpacing(0.5.scale)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Journal.Empty.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Journal.Empty")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBottomLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Font.Poppins.bold(size: 16.scale))
            .textAlignment(.center)
            .lineHeight(24.scale)
            .letterSpacing(0.5.scale)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Journal.Empty.Bottom".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
