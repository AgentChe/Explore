//
//  FPhotosSlider.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import Kingfisher

final class FPhotosSlider: UIScrollView {
    var didTapped: ((Weak<FPhotoView>) -> Void)?
    
    private var views = [FPhotoView]()
}

// MARK: API
extension FPhotosSlider {
    func setup(types: [FPhotoView.ElementType]) {
        views.forEach { $0.removeFromSuperview() }
        views = []
        
        contentSize = .zero
        
        var x = CGFloat(0)
        
        types.forEach { [weak self] type in
            let view = FPhotoView(type: type)
            view.frame.size = CGSize(width: 72.scale, height: 72.scale)
            view.frame.origin = CGPoint(x: x, y: 0)
            view.backgroundColor = UIColor.black
            view.layer.cornerRadius = 5.scale
            view.layer.borderColor = UIColor(red: 235 / 255, green: 240 / 255, blue: 1, alpha: 1).cgColor
            view.layer.borderWidth = 1.scale
            view.layer.masksToBounds = true
            
            self?.addSubview(view)
            self?.views.append(view)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped(gesture:)))
            view.addGestureRecognizer(tapGesture)
            view.isUserInteractionEnabled = true
            
            x += 84.scale
        }
        
        contentSize = CGSize(width: CGFloat(views.count) * 72.scale + CGFloat(views.count - 1) * 12.scale,
                             height: 72.scale)
    }
}

// MARK: Private
private extension FPhotosSlider {
    @objc
    func tapped(gesture: UITapGestureRecognizer) {
        guard let view = gesture.view as? FPhotoView else {
            return
        }
        
        didTapped?(Weak(view))
    }
}
