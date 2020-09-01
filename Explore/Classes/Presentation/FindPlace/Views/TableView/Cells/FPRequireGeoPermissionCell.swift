//
//  FPRequireGeoPermissionCell.swift
//  Explore
//
//  Created by Andrey Chernyshev on 30.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class FPRequireGeoPermissionCell: UITableViewCell {
    weak var delegate: FindPlaceTableDelegate?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var requireButton = makeRequireButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private

private extension FPRequireGeoPermissionCell {
    @objc
    func requireButtonTapped() {
        delegate?.findPlaceTableDidRequireGeoPermission()
    }
}

// MARK: Make constraints

private extension FPRequireGeoPermissionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            requireButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            requireButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -160.scale),
            requireButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 28.scale),
            requireButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            requireButton.heightAnchor.constraint(equalToConstant: 48.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension FPRequireGeoPermissionCell {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.SFProText.bold(size: 22.scale)
        view.textColor = UIColor.white
        view.numberOfLines = 0
        view.textAlignment = .left
        view.text = "FindPlace.FPRequireGeoPermissionCell.Title".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeRequireButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        view.layer.cornerRadius = 16.scale
        view.setTitleColor(UIColor.black, for: .normal)
        view.setTitle("FindPlace.FPRequireGeoPermissionCell.Button".localized, for: .normal)
        view.titleLabel?.font = Font.SFCompactText.regular(size: 18.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(requireButtonTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
}
