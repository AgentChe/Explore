//
//  GeoLocationManagerDelegate.swift
//  Explore
//
//  Created by Andrey Chernyshev on 05.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol GeoLocationManagerDelegate: class {
    func geoLocationManager(changed authorizationStatus: GLAuthorizationStatus)
    func geoLocationManager(justDetermine currentLocation: Coordinate)
    func geoLocationManager(continuoslyKeep currentLocation: Coordinate)
    func geoLocationManager(error: Error)
}

extension GeoLocationManagerDelegate {
    func geoLocationManager(changed authorizationStatus: GLAuthorizationStatus) {}
    func geoLocationManager(justDetermine currentLocation: Coordinate) {}
    func geoLocationManager(continuoslyKeep currentLocation: Coordinate) {}
    func geoLocationManager(error: Error) {}
}
