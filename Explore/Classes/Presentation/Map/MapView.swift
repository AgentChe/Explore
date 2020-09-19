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
    lazy var radiusLabel = makeRadiusLabel()
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
            radiusLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            radiusLabel.bottomAnchor.constraint(equalTo: tripButton.topAnchor, constant: ScreenSize.isIphoneXFamily ? -77.scale : -50.scale)
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
    
    func makeRadiusLabel() -> PaddingLabel {
        let view = PaddingLabel()
        view.leftInset = 12.scale
        view.rightInset = 12.scale
        view.topInset = 6.scale
        view.bottomInset = 6.scale
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = 8.scale
        view.layer.masksToBounds = true
        view.font = Font.SFProText.regular(size: 17.scale)
        view.textColor = UIColor.white
        view.textAlignment = .center
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
