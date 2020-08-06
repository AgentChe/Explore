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
    override init(frame: CGRect, camera: GMSCameraPosition) {
        super.init(frame: frame, camera: camera)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
