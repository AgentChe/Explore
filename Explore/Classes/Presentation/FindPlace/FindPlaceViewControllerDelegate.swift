//
//  FindPlaceViewControllerDelegate.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol FindPlaceViewControllerDelegate: class {
    func findPlaceViewControllerTripCreated()
    func findPlaceViewControllerNeedPayment()
}

extension FindPlaceViewControllerDelegate {
    func findPlaceViewControllerTripCreated() {}
    func findPlaceViewControllerNeedPayment() {}
}
