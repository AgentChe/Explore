//
//  FindPlaceTableDelegate.swift
//  Explore
//
//  Created by Andrey Chernyshev on 30.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol FindPlaceTableDelegate: class {
    func findPlaceTableDidRequireGeoPermission()
    func findPlaceTableDidNavigateToSettings()
    func findPlaceTableDidSelected(whatYourSearchIntent tag: FPWhatYourSearchIntentCell.Tag)
    func findPlaceTableDidSelected(whatLikeGet tag: FPWhatLikeGetCell.Tag)
    func findPlaceTableDidSetRadius(radiusBundle: FPTableRadiusBundle)
    func findPlaceTableDidStart()
    func findPlaceTableDidReset()
}

extension FindPlaceTableDelegate {
    func findPlaceTableDidRequireGeoPermission() {}
    func findPlaceTableDidNavigateToSettings() {}
    func findPlaceTableDidSelected(whatYourSearchIntent tag: FPWhatYourSearchIntentCell.Tag) {}
    func findPlaceTableDidSelected(whatLikeGet tag: FPWhatLikeGetCell.Tag) {}
    func findPlaceTableDidSetRadius(radiusBundle: FPTableRadiusBundle) {}
    func findPlaceTableDidStart() {}
    func findPlaceTableDidReset() {}
}
