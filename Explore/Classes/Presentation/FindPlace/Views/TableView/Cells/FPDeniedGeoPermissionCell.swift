//
//  FPDeniedGeoPermissionCell.swift
//  Explore
//
//  Created by Andrey Chernyshev on 31.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class FPDeniedGeoPermissionCell: UITableViewCell {
    weak var delegate: FindPlaceTableDelegate?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var settingsButton = makeSettingsButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private

private extension FPDeniedGeoPermissionCell {
    @objc
    func settingsButtonTapped() {
        delegate?.findPlaceTableDidNavigateToSettings()
    }
}

// MARK: Make constraints

private extension FPDeniedGeoPermissionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            settingsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            settingsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32.scale),
            settingsButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 28.scale),
            settingsButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            settingsButton.heightAnchor.constraint(equalToConstant: 48.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension FPDeniedGeoPermissionCell {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.SFProText.bold(size: 22.scale)
        view.textColor = UIColor.white
        view.numberOfLines = 0
        view.textAlignment = .left
        view.text = "FindPlace.FPDenieedGeoPermission.Title".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeSettingsButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        view.layer.cornerRadius = 16.scale
        view.setTitleColor(UIColor.black, for: .normal)
        view.setTitle("FindPlace.FPDenieedGeoPermission.SettingsButton".localized, for: .normal)
        view.titleLabel?.font = Font.SFCompactText.regular(size: 18.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
}
