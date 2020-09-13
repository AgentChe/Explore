//
//  FPRadiusCell.swift
//  Explore
//
//  Created by Andrey Chernyshev on 01.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class FPRadiusCell: UITableViewCell {
    weak var delegate: FindPlaceTableDelegate?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var radiusSlider = makeRadiusSlider()
    lazy var radiusLabel = makeRadiusLabel()
    lazy var continueButton = makeContinueButton()
    
    private var bundle: FPTableRadiusBundle!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(bundle: FPTableRadiusBundle) {
        guard self.bundle != bundle else {
            return
        }
        
        self.bundle = bundle
        
        radiusLabel.text = String(format: "FindPlace.FPRadiusCell.Value".localized, bundle.radius)
        
        let selectedColor = UIColor.white.withAlphaComponent(0.9)
        let unselectedColor = UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 0.2)
        
        continueButton.backgroundColor = bundle.applied ? unselectedColor : selectedColor
        continueButton.isUserInteractionEnabled = !bundle.applied
        
        radiusSlider.value = CGFloat(bundle.radius)
        radiusSlider.layout()
        radiusSlider.isUserInteractionEnabled = !bundle.applied
    }
}

// MARK: Private

private extension FPRadiusCell {
    @objc
    func continueButtonTapped() {
        guard !bundle.applied else {
            return
        }
        
        let radius = Int(radiusSlider.value)
        
        bundle.setApplied(true)
        bundle.setRadius(radius)
        
        delegate?.findPlaceTableDidSetRadius(radiusBundle: bundle)
    }
}

// MARK: Make constraints

private extension FPRadiusCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            radiusSlider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            radiusSlider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -120.scale),
            radiusSlider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 28.scale)
        ])
        
        NSLayoutConstraint.activate([
            radiusLabel.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -104.scale),
            radiusLabel.centerYAnchor.constraint(equalTo: radiusSlider.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            continueButton.topAnchor.constraint(equalTo: radiusSlider.bottomAnchor, constant: 28.scale),
            continueButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            continueButton.heightAnchor.constraint(equalToConstant: 48.scale),
            continueButton.widthAnchor.constraint(equalToConstant: 140.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension FPRadiusCell {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.SFProText.bold(size: 22.scale)
        view.textColor = UIColor.white
        view.numberOfLines = 0
        view.textAlignment = .left
        view.text = "FindPlace.FPRadiusCell.Title".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeRadiusSlider() -> FPRadiusSlider {
        let view = FPRadiusSlider()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        
        view.didChangedValue = { [weak self] value in
            self?.radiusLabel.text = String(format: "FindPlace.FPRadiusCell.Value".localized, Int(value))
        }
        
        return view
    }
    
    func makeRadiusLabel() -> PaddingLabel {
        let view = PaddingLabel()
        view.leftInset = 8.scale
        view.rightInset = 8.scale
        view.topInset = 8.scale
        view.bottomInset = 8.scale
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = 8.scale
        view.layer.masksToBounds = true
        view.font = Font.SFProText.regular(size: 17.scale)
        view.textColor = UIColor.white
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        view.layer.cornerRadius = 16.scale
        view.setTitleColor(UIColor.black, for: .normal)
        view.setTitle("Continue".localized, for: .normal)
        view.titleLabel?.font = Font.SFCompactText.regular(size: 18.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
}
