//
//  GoogleMapView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 06.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import GoogleMaps

final class GoogleMapView: GMSMapView {
    private var placeMarker: GMSMarker?
    
    override init(frame: CGRect, camera: GMSCameraPosition) {
        super.init(frame: frame, camera: camera)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Manage

extension GoogleMapView {
    func addPlaceMarker(with coordinate: Coordinate) {
        removePlaceMarker()
        
        placeMarker = GMSMarker()
        placeMarker?.position = CLLocationCoordinate2D(latitude: coordinate.latitude,
                                                       longitude: coordinate.longitude)
        placeMarker?.map = self
    }
    
    func removePlaceMarker() {
        placeMarker?.map = nil
        placeMarker = nil
    }
}
