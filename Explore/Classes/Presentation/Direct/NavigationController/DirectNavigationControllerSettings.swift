//
//  DirectNavigationControllerSettings.swift
//  Explore
//
//  Created by Andrey Chernyshev on 22.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

struct DirectNavigationControllerSettings {
    let backgroundImage: UIImage
    let shadowImage: UIImage
    let isTranslucent: Bool
    let tintColor: UIColor
    let titleTextAttrributes: [NSAttributedString.Key: Any]
}

// MARK: Make

extension DirectNavigationControllerSettings {
    static func `default`() -> DirectNavigationControllerSettings {
        DirectNavigationControllerSettings(backgroundImage: UIImage(),
                                           shadowImage: UIImage(),
                                           isTranslucent: true,
                                           tintColor: UIColor(red: 233 / 255, green: 233 / 255, blue: 233 / 255, alpha: 1),
                                           titleTextAttrributes: TextAttributes()
                                            .textColor(UIColor(red: 233 / 255, green: 233 / 255, blue: 233 / 255, alpha: 1))
                                            .font(Font.SFProText.semibold(size: 17.scale))
                                            .textAlignment(.center)
                                            .dictionary)
    }
}
