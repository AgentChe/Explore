//
//  OnboardingView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 27.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class OnboardingView: UIView {
    lazy var slider = makeSlider()
    lazy var indicatorsView = makeIndicatorsView()
    lazy var enjoyNowButton = makeEnjoyNowButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension OnboardingView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor),
            slider.topAnchor.constraint(equalTo: topAnchor),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            indicatorsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            indicatorsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            indicatorsView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -75.scale : -30.scale)
        ])
        
        NSLayoutConstraint.activate([
            enjoyNowButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            enjoyNowButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            enjoyNowButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -61.scale : -25.scale),
            enjoyNowButton.heightAnchor.constraint(equalToConstant: 50.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OnboardingView {
    func makeSlider() -> OnboardingSlider {
        let view = OnboardingSlider()
        view.backgroundColor = UIColor(red: 53 / 255, green: 53 / 255, blue: 53 / 255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIndicatorsView() -> OnboardingSliderIndicatorsView {
        let view = OnboardingSliderIndicatorsView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEnjoyNowButton() -> UIButton {
        let attrs = TextAttributes()
            .font(Font.Poppins.regular(size: 17.scale))
            .textColor(UIColor(red: 21 / 255, green: 21 / 255, blue: 34 / 255, alpha: 1))
            .lineHeight(24.scale)
            .letterSpacing(-0.18.scale)
            .underlineStyle(NSUnderlineStyle.single)
            .underlineColor(UIColor.white)
        
        let view = UIButton()
        view.isHidden = true
        view.layer.cornerRadius = 25.scale
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = UIColor(red: 109 / 255, green: 95 / 255, blue: 162 / 255, alpha: 1).cgColor
        view.backgroundColor = UIColor.white
        view.setAttributedTitle("Onboarding.EnjoyNow".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
