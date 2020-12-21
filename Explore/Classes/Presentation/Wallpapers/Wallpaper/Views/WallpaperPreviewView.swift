//
//  WallpaperPreviewView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 16.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class WallpaperPreviewView: UIView {
    lazy var timeLabel = makeLabel()
    lazy var dateLabel = makeLabel()
    lazy var lightButtonAccessoryImageView = makeButtonAccessoryImageView(imageName: "Wallpaper.Light")
    lazy var cameraButtonAccessoryImageView = makeButtonAccessoryImageView(imageName: "Wallpaper.Camera")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API

extension WallpaperPreviewView {
    func update() {
        let currentDate = Date()
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let time = timeFormatter.string(from: currentDate)
        
        timeLabel.attributedText = time.attributed(with: TextAttributes()
            .font(Font.SFProText.regular(size: 80.scale))
            .lineHeight(81.scale)
            .textAlignment(.center)
            .letterSpacing(-0.001)
            .textColor(UIColor.white))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM"
        let date = dateFormatter.string(from: currentDate)
        
        dateLabel.attributedText = date.attributed(with: TextAttributes()
            .font(Font.SFProText.regular(size: 22.scale))
            .lineHeight(26.scale)
            .textAlignment(.center)
            .letterSpacing(0.014)
            .textColor(UIColor.white))
    }
}

// MARK: Make constraints

private extension WallpaperPreviewView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 106.scale)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 2.scale)
        ])
        
        NSLayoutConstraint.activate([
            lightButtonAccessoryImageView.widthAnchor.constraint(equalToConstant: 50.scale),
            lightButtonAccessoryImageView.heightAnchor.constraint(equalToConstant: 50.scale),
            lightButtonAccessoryImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 46.scale),
            lightButtonAccessoryImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50.scale)
        ])
        
        NSLayoutConstraint.activate([
            cameraButtonAccessoryImageView.widthAnchor.constraint(equalToConstant: 50.scale),
            cameraButtonAccessoryImageView.heightAnchor.constraint(equalToConstant: 50.scale),
            cameraButtonAccessoryImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -46.scale),
            cameraButtonAccessoryImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension WallpaperPreviewView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButtonAccessoryImageView(imageName: String) -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = UIColor.clear
        view.image = UIImage(named: imageName)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
