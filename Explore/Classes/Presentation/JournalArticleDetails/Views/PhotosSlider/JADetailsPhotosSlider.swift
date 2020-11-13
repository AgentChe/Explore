//
//  JADetailsPhotosSlider.swift
//  Explore
//
//  Created by Andrey Chernyshev on 12.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import Kingfisher

final class JSDetailsPhotosSlider: UIView {
    private lazy var slideIndicators = [UIView]()
    private lazy var slides = [UIImageView]()
    
    private var urls: [URL] = []
    
    private var isConfigured = false
    
    func setup(urls: [URL]) {
        slideIndicators.forEach { $0.removeFromSuperview() }
        slideIndicators = []
        
        slides.forEach { $0.removeFromSuperview() }
        slides = []
        
        subviews.forEach { $0.removeFromSuperview() }
        
        isConfigured = false
        
        self.urls = urls
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard !isConfigured && !urls.isEmpty && !isZeroFrame() else {
            return
        }
        
        configure()
        
        isConfigured = true
    }
}

// MARK: UIScrollViewDelegate
extension JSDetailsPhotosSlider: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let slideIndex = Int(round(scrollView.contentOffset.x / frame.width))
        
        for (index, slideIndicator) in slideIndicators.enumerated() {
            slideIndicator.backgroundColor = slideIndex == index ? UIColor.white : UIColor.white.withAlphaComponent(0.5)
        }
    }
}

// MARK: Private
private extension JSDetailsPhotosSlider {
    func configure() {
        backgroundColor = .black
        
        let scrollView = makeScrollView()
        scrollView.frame.size = CGSize(width: frame.width, height: frame.height)
        scrollView.frame.origin = CGPoint(x: 0, y: 0)
        scrollView.contentSize = CGSize(width: frame.width * CGFloat(urls.count), height: frame.height)
        scrollView.delegate = self
        addSubview(scrollView)
        
        var sliderIndicatorX = (frame.width - 8.scale * CGFloat(urls.count) + CGFloat(urls.count - 1) * 7.scale) / 2
        
        for (index, url) in urls.enumerated() {
            let slide = makeSlide()
            slide.frame.size = CGSize(width: frame.width, height: frame.height)
            slide.frame.origin = CGPoint(x: frame.width * CGFloat(index), y: 0)
            slide.kf.setImage(with: url)
            slides.append(slide)
            scrollView.addSubview(slide)
            
            let slideIndicator = makeSlideIndicator()
            slideIndicator.frame.size = CGSize(width: 8.scale, height: 8.scale)
            slideIndicator.frame.origin = CGPoint(x: sliderIndicatorX, y: frame.height - 80.scale)
            slideIndicator.backgroundColor = index == 0 ? UIColor.white : UIColor.white.withAlphaComponent(0.5)
            slideIndicators.append(slideIndicator)
            
            sliderIndicatorX += CGFloat(8.scale + 7.scale)
        }
    }
    
    func isZeroFrame() -> Bool {
        frame.width <= 0 || frame.height <= 0
    }
    
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        addSubview(view)
        return view
    }
    
    func makeSlide() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }
    
    func makeSlideIndicator() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 4.scale
        addSubview(view)
        return view
    }
}
