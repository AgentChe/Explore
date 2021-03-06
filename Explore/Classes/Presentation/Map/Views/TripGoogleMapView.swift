//
//  TripGoogleMapView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 28.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import GoogleMaps

final class TripGoogleMapView: GoogleMapView {
    var tripMarker: GMSMarker?
    var userPlacedMarker: GMSMarker?
    
    func setTripMarker(at coordinate: Coordinate) {
        if tripMarker == nil {
            tripMarker = GMSMarker()
            tripMarker?.iconView = CircleMarkerIconView(frame: CGRect(origin: .zero, size: CGSize(width: 153.scale, height: 153.scale)))
            tripMarker?.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            tripMarker?.map = self
        }
        
        tripMarker?.position = CLLocationCoordinate2D(latitude: coordinate.latitude,
                                                      longitude: coordinate.longitude)
    }
    
    func moveUserPlacedMarker(at coordinate: Coordinate) {
        if userPlacedMarker == nil {
            userPlacedMarker = GMSMarker()
            userPlacedMarker?.map = self
        }
        
        userPlacedMarker?.position = CLLocationCoordinate2D(latitude: coordinate.latitude,
                                                            longitude: coordinate.longitude)
    }
}
