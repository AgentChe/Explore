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
    }
}

// MARK: Lazy initialization

private extension OnboardingView {
    func makeSlider() -> OnboardingSlider {
        let view = OnboardingSlider()
        view.backgroundColor = UIColor(red: 29 / 255, green: 20 / 255, blue: 20 / 255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
