//
//  WallpaperActionsView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 16.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class WallpaperActionsView: UIView {
    lazy var closeButton = makeCloseButton()
    lazy var saveButton = makeActionButton(title: "Wallpaper.Save".localized)
    lazy var previewButton = makeActionButton(title: "Wallpaper.Preview".localized)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

private extension WallpaperActionsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 37.scale),
            closeButton.heightAnchor.constraint(lessThanOrEqualToConstant: 37.scale),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 48.scale)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            saveButton.heightAnchor.constraint(equalToConstant: 52.scale),
            saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -48.scale),
            saveButton.trailingAnchor.constraint(equalTo: previewButton.leadingAnchor, constant: -8.scale),
            saveButton.widthAnchor.constraint(equalTo: previewButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            previewButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -40.scale),
            previewButton.heightAnchor.constraint(equalToConstant: 52.scale),
            previewButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -48.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension WallpaperActionsView {
    func makeCloseButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Wallpaper.Close"), for: .normal)
        view.layer.cornerRadius = 18.5.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeActionButton(title: String) -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.layer.cornerRadius = 26.scale
        view.layer.masksToBounds = true
        view.setTitle(title, for: .normal)
        view.setTitleColor(UIColor(red: 232 / 255, green: 232 / 255, blue: 232 / 255, alpha: 1), for: .normal)
        view.titleLabel?.font = Font.SFProText.bold(size: 15.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
