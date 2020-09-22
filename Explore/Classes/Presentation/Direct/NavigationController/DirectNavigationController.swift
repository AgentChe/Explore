//
//  DirectNavigationController.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class DirectNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apply(settings: .default())
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .default
    }
}

// MARK: API

extension DirectNavigationController {
    func apply(settings: DirectNavigationControllerSettings) {
        navigationBar.setBackgroundImage(settings.backgroundImage, for: .default)
        navigationBar.shadowImage = settings.shadowImage
        navigationBar.isTranslucent = settings.isTranslucent
        navigationBar.tintColor = settings.tintColor
        navigationBar.titleTextAttributes = settings.titleTextAttrributes
    }
}
