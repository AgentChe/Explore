//
//  Device.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 06/06/2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

enum ScreenSize {
    private static let maxHeightSmallDevice: CGFloat = 1334
    private static let maxHeightVerySmallDevice: CGFloat = 1136
    
    static let bounds: CGRect = (UIScreen.main.bounds)
    static let width: CGFloat = (bounds.width)
    static let height: CGFloat = (bounds.height)
    static let maxLength: CGFloat = (max(width, height))
    static let minLength: CGFloat = (min(width, height))
    
    static let isIpad = (UI_USER_INTERFACE_IDIOM() == .pad)
    static let isIphone = (UI_USER_INTERFACE_IDIOM() == .phone)
    static let isRetina = (UIScreen.main.scale >= 2.0)
    static let isIphone4 = (isIphone && maxLength < 568.0)
    static let isIphone5 = (isIphone && maxLength == 568.0)
    static let isIphone6 = (isIphone && maxLength == 667.0)
    static let isIphone6Plus = (isIphone && maxLength == 736.0)
    static let isIphoneX = (isIphone && maxLength == 812.0)
    static let isIphoneXMax = (isIphone && maxLength == 896.0)
    static let isIphoneXFamily = (isIphone && maxLength / minLength > 2.0)
    
    static let topOffset: CGFloat = isIphoneXFamily ? 24.0 : 0.0
    static let bottomOffset: CGFloat = isIphoneXFamily ? 34.0 : 0.0
    
    static let statusBarSize = UIApplication.shared.statusBarFrame.size
    static let statusBarHeight = statusBarSize.height
    
    static let tabBarHeight: CGFloat = 49
    
    static var isSmallScreen: Bool {
        UIScreen.main.nativeBounds.height <= maxHeightSmallDevice
    }
    
    static var isVerySmallScreen: Bool {
        UIScreen.main.nativeBounds.height <= maxHeightVerySmallDevice
    }
    
    static var hasTopNotch: Bool {
        if #available(iOS 11.0,  *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }

        return false
    }
    
    static var hasBottomNotch: Bool {
        if #available(iOS 11.0,  *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0 > 20
        }

        return false
    }
}
