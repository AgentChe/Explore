//
//  OnboardingView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 07.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class OnboardingView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var okButton = makeOkButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
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
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 200.scale : 150.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            okButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48.scale),
            okButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48.scale),
            okButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale),
            okButton.heightAnchor.constraint(equalToConstant: 56.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension OnboardingView {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor.black
        view.font = UIFont.systemFont(ofSize: 24.scale, weight: .bold)
        view.text = "Onboarding.Title".localized
        view.numberOfLines = 0
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor.black
        view.font = UIFont.systemFont(ofSize: 17.scale, weight: .regular)
        view.text = "Onboarding.SibTitle".localized
        view.numberOfLines = 0
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeOkButton() -> UIButton {
        let view = UIButton()
        view.setTitle("OK".localized, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 17.scale, weight: .semibold)
        view.setTitleColor(UIColor.white, for: .normal)
        view.backgroundColor = UIColor(red: 63 / 255, green: 63 / 255, blue: 63 / 255, alpha: 1)
        view.layer.cornerRadius = 8.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
