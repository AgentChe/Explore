//
//  FPPreloaderAnimationView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 05.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class FPPreloaderAnimationView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var imageView = makeImageView()
    lazy var bottomLabel = makeBottomLabel()
    
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
private extension FPPreloaderAnimationView {
    func configure() {
        backgroundColor = UIColor.black
    }
}

// MARK: Make constraints
private extension FPPreloaderAnimationView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 70.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 285.scale),
            imageView.heightAnchor.constraint(equalToConstant: 285.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 228.scale)
        ])
        
        NSLayoutConstraint.activate([
            bottomLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            bottomLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            bottomLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -126.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension FPPreloaderAnimationView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Font.Poppins.regular(size: 18.scale))
            .lineHeight(27.scale)
            .letterSpacing(0.5.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "FindPlace.FPPreloaderAnimation.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "FindPlace.Preloader.Image")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBottomLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white.withAlphaComponent(0.5))
            .font(Font.SFProText.regular(size: 22.scale))
            .lineHeight(28.scale)
            .letterSpacing(0.6.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "FindPlace.FPPreloaderAnimation.Bottom".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
