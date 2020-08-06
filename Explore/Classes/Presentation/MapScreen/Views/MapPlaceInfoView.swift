//
//  PlaceInfoView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 06.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import Kingfisher

final class MapPlaceInfoView: UIView {
    lazy var separator = makeSeparator()
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(place: Place) {
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        
        if let url = URL(string: place.imageUrl) {
            imageView.kf.setImage(with: url)
        }
        
        label.text = place.about
    }
}

// MARK: Make constraints

private extension MapPlaceInfoView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            separator.centerXAnchor.constraint(equalTo: centerXAnchor),
            separator.topAnchor.constraint(equalTo: topAnchor, constant: 8.scale),
            separator.heightAnchor.constraint(equalToConstant: 2.scale),
            separator.widthAnchor.constraint(equalToConstant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 24.scale),
            imageView.widthAnchor.constraint(equalToConstant: 64.scale),
            imageView.heightAnchor.constraint(equalToConstant: 64.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 24.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -32.scale : -16.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension MapPlaceInfoView {
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        view.layer.cornerRadius = 1.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8.scale
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 10
        view.textColor = UIColor.black
        view.font = UIFont.systemFont(ofSize: 15.scale, weight: .regular)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
