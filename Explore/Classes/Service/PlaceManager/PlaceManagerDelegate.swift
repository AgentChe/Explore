//
//  PlaceManagerDelegate.swift
//  Explore
//
//  Created by Andrey Chernyshev on 06.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol PlaceManagerDelegate: class {
    func placeManager(updated: Place)
}

extension PlaceManagerDelegate {
    func placeManager(updated: Place) {}
}
