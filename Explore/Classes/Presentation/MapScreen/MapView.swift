//
//  MapView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 05.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import GoogleMaps

final class MapView: UIView {
    lazy var mapView = makeMapView()
    lazy var randomizeButton = makeRandomizeButton()
    lazy var activityIndicator = makeActivityIndicator()
    lazy var placeInfoView = makePlaceInfoView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            randomizeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48.scale),
            randomizeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48.scale),
            randomizeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale),
            randomizeButton.heightAnchor.constraint(equalToConstant: 56.scale)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: randomizeButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: randomizeButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            placeInfoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeInfoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            placeInfoView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension MapView {
    func makeMapView() -> GoogleMapView {
        let camera = GMSCameraPosition(latitude: 55.753804, longitude: 37.621645, zoom: 15)
        
        let view = GoogleMapView(frame: .zero, camera: camera)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeRandomizeButton() -> UIButton {
        let view = UIButton()
        view.setTitle("Map.Randomize".localized, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 17.scale, weight: .semibold)
        view.setTitleColor(UIColor.white, for: .normal)
        view.backgroundColor = UIColor(red: 63 / 255, green: 63 / 255, blue: 63 / 255, alpha: 1)
        view.layer.cornerRadius = 8.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeActivityIndicator() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.stopAnimating()
        view.style = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePlaceInfoView() -> MapPlaceInfoView {
        let view = MapPlaceInfoView()
        view.isHidden = true
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 24.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
