//
//  WallpaperView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 16.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class WallpaperView: UIView {
    lazy var wallpaperImageView = makeWallpaperImageView()
    lazy var actionsView = makeActionsView()
    lazy var previewView = makePreviewView()
    lazy var notifyAboutSavedLabel = makeNotifyAboutSavedLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.black
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

private extension WallpaperView {
    func makeConstraints() {
        [
            wallpaperImageView, actionsView, previewView
        ]
        .forEach {
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: trailingAnchor),
                $0.topAnchor.constraint(equalTo: topAnchor),
                $0.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        
        NSLayoutConstraint.activate([
            notifyAboutSavedLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            notifyAboutSavedLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension WallpaperView {
    func makeWallpaperImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeActionsView() -> WallpaperActionsView {
        let view = WallpaperActionsView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreviewView() -> WallpaperPreviewView {
        let view = WallpaperPreviewView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNotifyAboutSavedLabel() -> PaddingLabel {
        let view = PaddingLabel()
        view.leftInset = 40.scale
        view.rightInset = 40.scale
        view.topInset = 20.scale
        view.bottomInset = 20.scale
        view.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        view.layer.cornerRadius = 12.scale
        view.layer.masksToBounds = true
        view.font = Font.SFProText.bold(size: 17.scale)
        view.textColor = UIColor.black.withAlphaComponent(0.4)
        view.textAlignment = .center
        view.text = "Wallpaper.SavedToCameraRoll".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
