//
//  OnboardingSliderIndicatorView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 06.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class OnboardingSliderIndicatorsView: UIView {
    var count: Int = 0 {
        didSet {
            reset()
        }
    }
    
    var index: Int = 0 {
        didSet {
            updateMover()
        }
    }
    
    private var indicators = [UIView]()
    private var mover = UIView()
    
    private var isConfigurated = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard !isConfigurated && frame.size != .zero else {
            return
        }
        
        updateIndicators()
        updateMover()
        
        isConfigurated = true
    }
}

// MARK: Private
private extension OnboardingSliderIndicatorsView {
    func configure() {
        mover.frame.size = CGSize(width: 16.scale, height: 8.scale)
        mover.backgroundColor = UIColor.white
        mover.layer.cornerRadius = 4.scale
        addSubview(mover)
    }
    
    func reset() {
        indicators.forEach { $0.removeFromSuperview() }
        indicators = []
        
        isConfigurated = false
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func updateIndicators() {
        let slidesContainerWidth = CGFloat(count) * 8.scale + CGFloat((count - 1)) * 9.scale
        let equalWidths = frame.width - slidesContainerWidth
        var slideIndicatorX = equalWidths / 2
        
        for _ in 0..<count {
            let slideIndicator = CircleView()
            slideIndicator.frame.size = CGSize(width: 8.scale, height: 8.scale)
            slideIndicator.frame.origin = CGPoint(x: slideIndicatorX, y: 0)
            slideIndicator.backgroundColor = UIColor(red: 142 / 255, green: 142 / 255, blue: 147 / 255, alpha: 0.6)
            indicators.append(slideIndicator)
            addSubview(slideIndicator)
            slideIndicatorX += 17.scale
        }
        
        bringSubviewToFront(mover)
    }
    
    func updateMover() {
        mover.isHidden = count <= 0
        
        guard count > 0 else {
            return
        }
        
        guard indicators.indices.contains(index) else {
            return
        }
        
        let indicator = indicators[index]
        mover.center = indicator.center
    }
}
