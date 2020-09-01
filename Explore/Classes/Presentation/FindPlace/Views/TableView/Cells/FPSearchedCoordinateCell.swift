//
//  FPSearchedCoordinateCell.swift
//  Explore
//
//  Created by Andrey Chernyshev on 30.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import GoogleMaps

final class FPSearchedCoordinateCell: UITableViewCell {
    lazy var titleLabel = makeTitleLabel()
    lazy var mapView = makeMapView()
    lazy var mapSubTitleLabel = makeMapSubTitleLabel()
    
    var marker: GMSMarker?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(coordinate: Coordinate) {
        titleLabel.text = String(format: "FindPlace.FPSearchedCoordinateCell.Title".localized, coordinate.latitude, coordinate.longitude)
        
        let camera = GMSCameraPosition(latitude: coordinate.latitude,
                                       longitude: coordinate.longitude,
                                       zoom: 15)
        let update = GMSCameraUpdate.setCamera(camera)
        mapView.moveCamera(update)
        
        marker = GMSMarker()
        marker?.position = CLLocationCoordinate2D(latitude: coordinate.latitude,
                                                  longitude: coordinate.longitude)
        marker?.map = mapView
    }
}

// MARK: Make constraints

private extension FPSearchedCoordinateCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -126.scale),
            mapView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 28.scale),
            mapView.heightAnchor.constraint(equalToConstant: 119.scale)
        ])
        
        NSLayoutConstraint.activate([
            mapSubTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            mapSubTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -126.scale),
            mapSubTitleLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            mapSubTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension FPSearchedCoordinateCell {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.SFProText.bold(size: 22.scale)
        view.textColor = UIColor.white
        view.numberOfLines = 0
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeMapView() -> GMSMapView {
        let view = GMSMapView()
        view.layer.cornerRadius = 24.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeMapSubTitleLabel() -> PaddingLabel {
        let view = PaddingLabel()
        view.leftInset = 24.scale
        view.rightInset = 24.scale
        view.topInset = 16.scale
        view.bottomInset = 16.scale
        view.numberOfLines = 0
        view.textColor = UIColor(red: 235 / 255, green: 235 / 255, blue: 245 / 255, alpha: 0.6)
        view.font = Font.SFProText.regular(size: 13.scale)
        view.text = "FindPlace.FPSearchedCoordinateCell.MapSubtitle".localized
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.layer.cornerRadius = 24.scale
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.masksToBounds = true 
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
