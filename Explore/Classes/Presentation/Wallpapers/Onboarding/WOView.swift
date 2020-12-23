//
//  WOView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 22.12.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class WOView: UIView {
    lazy var slider = makeSlider()
    lazy var label = makeLabel()
    lazy var indicatorsView = makeIndicatorsView()
    lazy var button = makeButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension WOView {
    func configure() {
        backgroundColor = UIColor.black
    }
}

// MARK: Make Constraints
private extension WOView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor),
            slider.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 20.scale : 8.scale),
            slider.heightAnchor.constraint(equalToConstant: 399.scale)
        ])
        
        NSLayoutConstraint.activate([
            indicatorsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            indicatorsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            indicatorsView.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 26.scale : 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 45.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -45.scale),
            label.bottomAnchor.constraint(equalTo: button.topAnchor, constant: ScreenSize.isIphoneXFamily ? -35.scale : -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            button.heightAnchor.constraint(equalToConstant: 50.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -44.scale : -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WOView {
    func makeSlider() -> WOSlider {
        let view = WOSlider()
        view.backgroundColor = UIColor.clear
        view.isPagingEnabled = true
        view.type = .rotary
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
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
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 21, green: 21, blue: 34))
            .textAlignment(.center)
            .font(Font.Poppins.semibold(size: 16.scale))
            .lineHeight(22.scale)
        
        let view = UIButton()
        view.setAttributedTitle("WallpapersOnboarding.Next".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 25.scale
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = UIColor(integralRed: 14, green: 14, blue: 14).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
