//
//  MapViewControllerDelegate.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol MapViewControllerDelegate: class {
    func mapViewControllerTripRemoved()
}

extension MapViewControllerDelegate {
    func mapViewControllerTripRemoved() {}
}
