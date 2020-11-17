//
//  FeedbackSuccessView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 14.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class FeedbackSuccessView: UIView {
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var button = makeButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension FeedbackSuccessView {
    func configure() {
        backgroundColor = UIColor.black
    }
}

// MARK: Make constraints
private extension FeedbackSuccessView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 223.scale),
            imageView.heightAnchor.constraint(equalToConstant: 260.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 232.scale : 132.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 39.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30.scale),
            button.heightAnchor.constraint(equalToConstant: 50.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -44.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension FeedbackSuccessView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Feedback.Success")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Font.Poppins.regular(size: 16.scale))
            .lineHeight(24.scale)
            .letterSpacing(0.5.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Feedback.Success.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor(red: 21 / 255, green: 21 / 255, blue: 34 / 255, alpha: 1))
            .font(Font.Poppins.regular(size: 16.scale))
            .lineHeight(22.scale)
            .letterSpacing(0.5.scale)
            .textAlignment(.center)
        
        let view = UIButton()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 25.scale
        view.setAttributedTitle("Feedback.Success.Button".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
