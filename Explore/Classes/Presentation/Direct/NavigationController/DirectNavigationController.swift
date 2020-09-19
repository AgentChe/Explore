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
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.tintColor = UIColor.white
        
        navigationBar.titleTextAttributes = TextAttributes()
            .textColor(UIColor.white)
            .font(Font.SFProText.semibold(size: 17.scale))
            .textAlignment(.center)
            .dictionary
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .default
    }
}
