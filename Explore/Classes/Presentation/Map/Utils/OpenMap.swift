//
//  OpenMap.swift
//  Explore
//
//  Created by Andrey Chernyshev on 28.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import CoreLocation
import MapKit

final class OpenMaps {}

// MARK: Apple Map

extension OpenMaps {
    static var canOpenAppleMaps: Bool {
        guard let url = URL(string: "maps://") else {
            return false
        }
        
        return UIApplication.shared.canOpenURL(url)
    }
    
    @discardableResult
    static func openAppleMaps(with coordinate: Coordinate) -> Bool {
        let location = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let placemark = MKPlacemark(coordinate: location, addressDictionary: nil)
        
        let targetMapItem = MKMapItem(placemark: placemark)

        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]

        let currentLocationMapItem = MKMapItem.forCurrentLocation()

        return MKMapItem.openMaps(with: [currentLocationMapItem, targetMapItem], launchOptions: options)
    }
}

// MARK: Google Map

extension OpenMaps {
    static var canOpenGoogleMaps: Bool {
        guard let url = URL(string: "comgooglemaps://") else {
            return false
        }
        
        return UIApplication.shared.canOpenURL(url)
    }
    
    @discardableResult
    static func openGoogleMaps(with coordinate: Coordinate) -> Bool {
        if
            let url = URL(string: "comgooglemaps://?saddr=&daddr=\(coordinate.latitude),\(coordinate.longitude)&directionsmode=driving"),
        UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        } else {
            if let url = URL(string:"https://apps.apple.com/ru/app/google-maps-transit-food/id585027354") {
                UIApplication.shared.open(url, options: [:])
            }
        }
        
        return true
    }
}

// MARK: Yandex Map

extension OpenMaps {
    static var canOpenYandexMaps: Bool {
        guard let url = URL(string: "yandexmaps://") else {
            return false
        }
        
        return UIApplication.shared.canOpenURL(url)
    }
    
    @discardableResult
    static func openYandexMaps(with coordinate: Coordinate) -> Bool {
        if
            let url = URL(string: "yandexmaps://build_route_on_map?lat_to=\(coordinate.latitude)&lon_to=\(coordinate.longitude)"),
        UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        } else {
            if let url = URL(string:"https://itunes.apple.com/ru/app/yandex.maps/id313877526?mt=8") {
                UIApplication.shared.open(url, options: [:])
            }
        }
        
        return true
    }
}
    
// MARK: 2Gis

extension OpenMaps {
    static var canOpenDGIS: Bool {
        guard let url = URL(string: "dgis://") else {
            return false
        }
        
        return UIApplication.shared.canOpenURL(url)
    }
    
    @discardableResult
    static func openDGis(with coordinate: Coordinate) -> Bool {
        if
            let url = URL(string: "dgis://2gis.ru/routeSearch/rsType/car/to/\(coordinate.longitude),\(coordinate.latitude)"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        } else {
            if let url = URL(string:"https://itunes.apple.com/ru/app/id481627348?mt=8") {
                UIApplication.shared.open(url, options: [:])
            }
        }
        
        return true
    }
}
