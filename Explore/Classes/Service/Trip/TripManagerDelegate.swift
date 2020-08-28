//
//  TripManagerDelegate.swift
//  Explore
//
//  Created by Andrey Chernyshev on 26.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol TripManagerDelegate: class {
    func tripManagerRemovedTrip()
    func tripManagerChanged(progressState: Bool)
}

extension TripManagerDelegate {
    func tripManagerTripWasRemoved() {}
    func tripManagerChanged(progressState: Bool) {}
}
