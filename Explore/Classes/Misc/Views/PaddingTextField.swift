//
//  PaddingTextField.swift
//  Surf
//
//  Created by Andrey Chernyshev on 15.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

class PaddingTextField: UITextField {
    var topInset: CGFloat = 5.0.scale
    var bottomInset: CGFloat = 5.0.scale
    var leftInset: CGFloat = 7.0.scale
    var rightInset: CGFloat = 7.0.scale
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}

// MARK: Private

private extension PaddingTextField {
    var padding: UIEdgeInsets {
        UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    }
}
