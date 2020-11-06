//
//  OnboardingAnimationView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 06.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class OnboardingAnimationView: UIView {
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
private extension OnboardingAnimationView {
    func configure() {
        backgroundColor = UIColor(red: 53 / 255, green: 53 / 255, blue: 53 / 255, alpha: 1)
    }
}

// MARK: Make constraints
private extension OnboardingAnimationView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 285.scale),
            imageView.heightAnchor.constraint(equalToConstant: 285.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 228.scale : 100.scale)
        ])
        
        NSLayoutConstraint.activate([
            bottomLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            bottomLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            bottomLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -126.scale : -80.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OnboardingAnimationView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Onboarding.Animate")
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
