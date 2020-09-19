//
//  CircleMarkerIconView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 19.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class CircleMarkerIconView: CircleView {
    private let innerView = CircleView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 153.scale, height: 153.scale)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        innerView.center = center
    }
}

// MARK: Private

private extension CircleMarkerIconView {
    func setup() {
        frame.origin = CGPoint.zero
        layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        layer.borderWidth = 3.scale
        backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
        innerView.center = center
        innerView.frame.size = CGSize(width: 25.scale, height: 25.scale)
        innerView.layer.borderWidth = 3.scale
        innerView.layer.borderColor = UIColor.white.cgColor
        innerView.backgroundColor = UIColor.black
        addSubview(innerView)
    }
}
