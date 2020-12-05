//
//  PaygateMainView.swift
//  SleepWell
//
//  Created by Andrey Chernyshev on 12/06/2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class PaygateMainView: UIView {
    lazy var backgroundImageView = makeBackgroundImageView()
    lazy var restoreButton = makeRestoreButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var leftOptionView = makeOptionView()
    lazy var rightOptionView = makeOptionView()
    lazy var continueButton = makeContinueButton()
    lazy var lockImageView = makeLockIconView()
    lazy var securedLabel = makeSecuredLabel()
    lazy var purchasePreloaderView = makePreloaderView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(paygate: PaygateMainOffer) {
        let options = paygate.options?.prefix(2) ?? []
        
        if let leftOption = options.first {
            leftOptionView.isHidden = false
            leftOptionView.isSelected = true
            leftOptionView.setup(option: leftOption)
        } else {
            leftOptionView.isHidden = true
        }
        
        if options.count > 1, let rightOption = options.last {
            rightOptionView.isHidden = false
            rightOptionView.setup(option: rightOption)
        } else {
            rightOptionView.isHidden = true
        }
    }
}

// MARK: Make constraints
private extension PaygateMainView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            restoreButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 41.scale : 31.scale),
            restoreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            restoreButton.heightAnchor.constraint(equalToConstant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: subTitleLabel.topAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            subTitleLabel.bottomAnchor.constraint(equalTo: leftOptionView.topAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            leftOptionView.widthAnchor.constraint(equalTo: rightOptionView.widthAnchor),
            leftOptionView.heightAnchor.constraint(equalToConstant: 185.scale),
            leftOptionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            leftOptionView.trailingAnchor.constraint(equalTo: rightOptionView.leadingAnchor, constant: -13.scale),
            leftOptionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -198.scale : -105.scale)
        ])
        
        NSLayoutConstraint.activate([
            rightOptionView.heightAnchor.constraint(equalToConstant: 185.scale),
            rightOptionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            rightOptionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -198.scale : -105.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.heightAnchor.constraint(equalToConstant: 50.scale),
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -84.scale : -46.scale)
        ])
        
        NSLayoutConstraint.activate([
            lockImageView.widthAnchor.constraint(equalToConstant: 12.scale),
            lockImageView.heightAnchor.constraint(equalToConstant: 16.scale),
            lockImageView.trailingAnchor.constraint(equalTo: securedLabel.leadingAnchor, constant: -10.scale),
            lockImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -43.scale : -18.scale)
        ])
        
        NSLayoutConstraint.activate([
            securedLabel.centerYAnchor.constraint(equalTo: lockImageView.centerYAnchor),
            securedLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            purchasePreloaderView.centerYAnchor.constraint(equalTo: continueButton.centerYAnchor),
            purchasePreloaderView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateMainView {
    func makeRestoreButton() -> UIButton {
        let atts = TextAttributes()
            .font(Font.Poppins.semibold(size: 17.scale))
            .lineHeight(27.scale)
            .textColor(UIColor.white.withAlphaComponent(0.9))
        
        let view = UIButton()
        view.setAttributedTitle("Paygate.Main.RestoreButton".localized.attributed(with: atts), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBackgroundImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Paygate.MainOffer.Background")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Font.Poppins.bold(size: 34.scale))
            .textColor(UIColor.white)
            .lineHeight(41.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Paygate.Main.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Font.Poppins.regular(size: 17.scale))
            .textColor(UIColor.white)
            .lineHeight(28.scale)
            .textAlignment(.left)
            .letterSpacing(-0.5.scale)
        
        let view = UILabel()
        view.attributedText = "Paygate.Main.SubTitle".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeOptionView() -> PaygateOptionView {
        let view = PaygateOptionView()
        view.alpha = 0
        view.isHidden = true
        view.layer.cornerRadius = 8.scale
        view.layer.borderWidth = 2.scale
        view.layer.borderColor = UIColor.white.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .font(Font.Poppins.semibold(size: 16.scale))
            .lineHeight(22.scale)
            .textColor(UIColor(red: 21 / 255, green: 21 / 255, blue: 34 / 255, alpha: 1))
            .textAlignment(.center)
        
        let view = UIButton()
        view.isHidden = true
        view.setAttributedTitle("Paygate.Main.Button".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = .white
        view.layer.cornerRadius = 28.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLockIconView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Paygate.MainOffer.Lock")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSecuredLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Font.Poppins.regular(size: 13.scale))
            .lineHeight(17.7.scale)
            .textColor(UIColor.white)
            .letterSpacing(-0.06.scale)
        
        let view = UILabel()
        view.attributedText = "Paygate.Main.Secured".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloaderView() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.style = .whiteLarge
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
