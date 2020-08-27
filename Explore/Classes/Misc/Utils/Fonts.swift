//
//  Fonts.swift
//  DoggyBag
//
//  Created by Andrey Chernyshev on 18/11/2019.
//  Copyright © 2019 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class Font {}

// MARK: Poppins

extension Font {
    final class Poppins {
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Poppins-Regular", size: size)!
        }
        
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "Poppins-Bold", size: size)!
        }

        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "Poppins-Medium", size: size)!
        }

        static func semibold(size: CGFloat) -> UIFont {
            UIFont(name: "Poppins-Semibold", size: size)!
        }

        static func light(size: CGFloat) -> UIFont {
            UIFont(name: "Poppins-Light", size: size)!
        }
    }
}

// MARK: OpenSans

extension Font {
    final class OpenSans {
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "OpenSans-Regular", size: size)!
        }

        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "OpenSans-Bold", size: size)!
        }

        static func semibold(size: CGFloat) -> UIFont {
            UIFont(name: "OpenSans-Semibold", size: size)!
        }

        static func light(size: CGFloat) -> UIFont {
            UIFont(name: "OpenSans-Light", size: size)!
        }
    }
}

// MARK: SFProText

extension Font {
    final class SFProText {
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "SFProText-Regular", size: size)!
        }
        
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "SFProText-Bold", size: size)!
        }

        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "SFProText-Medium", size: size)!
        }

        static func semibold(size: CGFloat) -> UIFont {
            UIFont(name: "SFProText-Semibold", size: size)!
        }

        static func light(size: CGFloat) -> UIFont {
            UIFont(name: "SFProText-Light", size: size)!
        }
    }
}

// MARK: SFCompactText

extension Font {
    final class SFCompactText {
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "SFCompactText-Regular", size: size)!
        }
        
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "SFCompactText-Bold", size: size)!
        }
    }
}

