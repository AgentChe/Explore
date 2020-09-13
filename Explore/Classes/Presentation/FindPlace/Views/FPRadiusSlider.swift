//
//  FPRadiusSlider.swift
//  Explore
//
//  Created by Andrey Chernyshev on 13.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class FPRadiusSlider: UIControl {
    struct Constants {
        static let minValue = CGFloat(1000)
        static let maxValue = CGFloat(10000)
    }
    
    var didChangedValue: ((CGFloat) -> Void)?
    
    var value: CGFloat = 2000 {
        didSet {
            if value > Constants.maxValue {
                value = Constants.maxValue
            } else if value < Constants.minValue {
                value = Constants.minValue
            }
        }
    }
    
    lazy var thumb = CALayer()
    lazy var line =  CALayer()
    
    private var isThumbing = false
    
    required override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public class var layerClass: AnyClass {
        CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if !isThumbing {
            updateLineHeight()
            updateHandlePositions()
        }
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: 222.scale, height: 36.scale)
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchLocation = touch.location(in: self)
        let thumbFrameForTouch = thumb.frame.insetBy(dx: -8.scale, dy: -8.scale)

        guard thumbFrameForTouch.contains(touchLocation) else { return
            false
        }
        
        isThumbing = true

        return true
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        guard isThumbing else {
            return false
        }

        let touchLocation = touch.location(in: self)
        let percentage = (touchLocation.x - line.frame.minX - 18.scale) / (line.frame.maxX - line.frame.minX)
        value = percentage * (Constants.maxValue - Constants.minValue) + Constants.minValue

        refresh()

        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        isThumbing = false
    }
}

// MARK: Api

extension FPRadiusSlider {
    func layout() {
        refresh()
    }
}

// MARK: Private

private extension FPRadiusSlider {
    func setup() {
        isAccessibilityElement = false
        
        layer.cornerRadius = 18.scale
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.1).cgColor,
            UIColor.black.cgColor
        ]
        
        line.backgroundColor = UIColor.clear.cgColor
        layer.addSublayer(line)

        thumb.frame.origin = .zero
        thumb.frame.size = CGSize(width: 36.scale, height: 36.scale)
        thumb.cornerRadius = 18.scale
        thumb.borderWidth = 3.scale
        thumb.borderColor = UIColor.white.cgColor
        thumb.backgroundColor = UIColor.black.cgColor
        layer.addSublayer(thumb)

        refresh()
    }
    
    func refresh() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        updateHandlePositions()
        CATransaction.commit()

        if isThumbing {
            didChangedValue?(value)
        }
    }
    
    func updateLineHeight() {
        let barSidePadding = 18.scale
        let yMiddle = frame.height / 2
        let lineLeftSide = CGPoint(x: barSidePadding, y: yMiddle)
        let lineRightSide = CGPoint(x: frame.width - barSidePadding, y: yMiddle)
        line.frame = CGRect(x: lineLeftSide.x,
                            y: lineLeftSide.y,
                            width: lineRightSide.x - lineLeftSide.x,
                            height: 2.scale)
    }
    
    func updateHandlePositions() {
        thumb.position = CGPoint(x: xPositionAlongLine(for: value), y: line.frame.midY)
    }
    
    func xPositionAlongLine(for value: CGFloat) -> CGFloat {
        let percentage = percentageAlongLine(for: value)
        let maxMinDif = line.frame.maxX - line.frame.minX
        let offset = percentage * maxMinDif
        return line.frame.minX + offset
    }
    
    func percentageAlongLine(for value: CGFloat) -> CGFloat {
        guard Constants.minValue < Constants.maxValue else {
            return 0
        }

        let maxMinDif = Constants.maxValue - Constants.minValue
        let valueSubtracted = value - Constants.minValue
        return valueSubtracted / maxMinDif
    }
    
    var gradientLayer: CAGradientLayer {
        layer as! CAGradientLayer
    }
}
