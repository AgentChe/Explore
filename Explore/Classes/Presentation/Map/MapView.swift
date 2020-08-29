//
//  MapView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 27.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import GoogleMaps

final class MapView: UIView {
    lazy var mapView = makeMapView()
    lazy var titleLabel = makeTitleLabel()
    lazy var tripButton = makeTripButton()
    lazy var activityIndicator = makeActivityIndicator()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func switchPreloader(in active: Bool) {
        tripButton.isUserInteractionEnabled = !active
        tripButton.alpha = active ? 0.2 : 1
        active ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}

// MARK: Make constraints

private extension MapView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 56.scale)
        ])
        
        NSLayoutConstraint.activate([
            tripButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            tripButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            tripButton.heightAnchor.constraint(equalToConstant: 48.scale),
            tripButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -64.scale)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: tripButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: tripButton.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension MapView {
    func makeMapView() -> TripGoogleMapView {
        let view = TripGoogleMapView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.SFProText.semibold(size: 17.scale)
        view.textAlignment = .center
        view.textColor = UIColor.white
        view.text = "Map.Title".localized
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTripButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1)
        view.layer.cornerRadius = 16.scale
        view.titleLabel?.font = Font.SFProText.regular(size: 18.scale)
        view.setTitle("Map.Navigate".localized, for: .normal)
        view.setTitleColor(UIColor.black, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeActivityIndicator() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.style = .white
        view.stopAnimating()
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
