//
//  WOSlider.swift
//  Explore
//
//  Created by Andrey Chernyshev on 23.12.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import iCarousel

final class WOSlider: iCarousel {
    var didSelected: ((Int) -> Void)?
    
    private var images = [UIImage]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension WOSlider {
    func setup(images: [UIImage]) {
        self.images = images
        
        reloadData()
    }
}

// MARK: iCarouselDataSource
extension WOSlider: iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
        images.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        if let imageView = view as? UIImageView {
            return imageView
        }
        
        let imageView = UIImageView()
        imageView.tag = index
        imageView.frame.origin = CGPoint(x: 0, y: 0)
        imageView.frame.size = CGSize(width: 245.scale, height: 399.scale)
        imageView.image = images[index]
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }
}

// MARK: iCarouselDelegate
extension WOSlider: iCarouselDelegate {
    func carouselDidScroll(_ carousel: iCarousel) {
        didSelected?(carousel.currentItemIndex)
    }
}

// MARK: Private
private extension WOSlider {
    func configure() {
        dataSource = self
        delegate = self
    }
}
