//
//  FeedbackSaveButton.swift
//  Explore
//
//  Created by Andrey Chernyshev on 14.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class FeedbackSaveButton: UIButton {
    private var title: NSAttributedString?
    private var animationLayer: CALayer?
    
    private var isAnimating = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isEnabled: Bool {
        didSet {
            updateEnabled()
        }
    }
}

// MARK: API
extension FeedbackSaveButton {
    func startAnimation() {
        guard !isAnimating else {
            return
        }
        
        isAnimating = true
        
        self.title = attributedTitle(for: .normal)
        setAttributedTitle(nil, for: .normal)
        
        isUserInteractionEnabled = false
        
        let animationLayer = makeAnimationLayer()
        self.animationLayer = animationLayer
        
        layer.addSublayer(animationLayer)
    }
    
    func stopAnimation() {
        guard isAnimating else {
            return
        }
        
        isAnimating = false
        
        setAttributedTitle(title, for: .normal)
        
        isUserInteractionEnabled = true
        
        animationLayer?.removeAllAnimations()
        animationLayer?.removeFromSuperlayer()
        animationLayer = nil
    }
}

// MARK: Private
private extension FeedbackSaveButton {
    func updateEnabled() {
        alpha = isEnabled ? 1 : 0.2
    }
    
    func makeAnimationLayer() -> CALayer {
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        animation.fromValue = 1
        animation.toValue = 0.2
        animation.duration = 1
        animation.repeatCount = .infinity
        
        let circle = CALayer()
        circle.frame = CGRect(x: 0, y: 0, width: 6.scale, height: 6.scale)
        circle.backgroundColor = UIColor.black.cgColor
        circle.cornerRadius = 3.scale
        circle.add(animation, forKey: nil)
        
        let layer = CAReplicatorLayer()
        layer.frame.size = CGSize(width: 18.scale, height: 6.scale)
        layer.frame.origin = CGPoint(x: (frame.width - 18.scale) / 2,
                                     y: frame.height / 2 - 3.scale)
        layer.instanceCount = 3
        layer.instanceTransform = CATransform3DMakeTranslation(6.scale, 0, 0)
        layer.addSublayer(circle)
        layer.instanceDelay = animation.duration / Double(layer.instanceCount)
        return layer
    }
}
