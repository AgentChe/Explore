//
//  GoogleMapView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 28.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import GoogleMaps

class GoogleMapView: GMSMapView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveCamera(to coordinate: Coordinate, zoom: Float? = nil) {
        let camera = GMSCameraUpdate.setCamera(GMSCameraPosition(latitude: coordinate.latitude,
                                                                 longitude: coordinate.longitude,
                                                                 zoom: zoom ?? self.camera.zoom))
        moveCamera(camera)
    }
}

// MARK: Private

private extension GoogleMapView {
    func configure() {
        guard let styleUrl = Bundle.main.url(forResource: "GoogleMapStyle", withExtension: "json") else {
            fatalError("Google map style not found in resource")
        }
        
        mapStyle = try? GMSMapStyle(contentsOfFileURL: styleUrl)
    }
}
