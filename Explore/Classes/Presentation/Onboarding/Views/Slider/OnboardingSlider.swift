//
//  OnboardingSlider.swift
//  Explore
//
//  Created by Andrey Chernyshev on 27.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class OnboardingSlider: UIView {
    weak var delegate: OnboardingSliderDelegate?
    
    private lazy var slides = [OnboardingSlideView]()
    
    private var models: [OnboardingSlide] = []
    
    private var isConfigurated = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard !isConfigurated && frame.size != .zero && !models.isEmpty else {
            return
        }
        
        configure()
        
        isConfigurated = true
    }
    
    func setup(models: [OnboardingSlide]) {
        slides.forEach { $0.removeFromSuperview() }
        slides = []
        
        subviews.forEach { $0.removeFromSuperview() }
        
        isConfigurated = false
        
        self.models = models
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}

// MARK: UIScrollViewDelegate
extension OnboardingSlider: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let slideIndex = Int(round(scrollView.contentOffset.x / frame.width))
        
        delegate?.onboardingSlider(changed: slideIndex)
    }
}

// MARK: Private
private extension OnboardingSlider {
    func configure() {
        let scrollView = UIScrollView()
        scrollView.frame.size = CGSize(width: frame.width, height: frame.height)
        scrollView.frame.origin = CGPoint(x: 0, y: 0)
        scrollView.contentSize = CGSize(width: frame.width * CGFloat(models.count), height: frame.height)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        addSubview(scrollView)
        
        for (index, model) in models.enumerated() {
            let slide = OnboardingSlideView()
            slide.frame.size = CGSize(width: frame.width, height: frame.height)
            slide.frame.origin = CGPoint(x: frame.width * CGFloat(index), y: 0)
            slide.backgroundColor = UIColor(red: 53 / 255, green: 53 / 255, blue: 53 / 255, alpha: 1)
            slide.setup(model: model)
            slides.append(slide)
            scrollView.addSubview(slide)
        }
    }
}
