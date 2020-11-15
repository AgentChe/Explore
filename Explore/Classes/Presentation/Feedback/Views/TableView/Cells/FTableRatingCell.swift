//
//  FTableRatingCell.swift
//  Explore
//
//  Created by Andrey Chernyshev on 14.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import Cosmos

final class FTableRatingCell: UITableViewCell {
    lazy var titleLabel = makeTitleLabel()
    lazy var ratingView = makeRatingView()
    
    private var element: FTableElement!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension FTableRatingCell {
    func setup(element: FTableElement) {
        self.element = element
        
        ratingView.rating = Double(element.rating ?? 0)
    }
}

// MARK: Private
private extension FTableRatingCell {
    func configure() {
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension FTableRatingCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            ratingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension FTableRatingCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Font.Poppins.bold(size: 14.scale))
            .lineHeight(21.scale)
            .letterSpacing(0.5.scale)
        
        let view = UILabel()
        view.attributedText = "Feedback.RatingCell.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeRatingView() -> CosmosView {
        let view = CosmosView()
        view.settings.totalStars = 5
        view.settings.emptyColor = UIColor(red: 235 / 255, green: 240 / 255, blue: 1, alpha: 1)
        view.settings.filledColor = UIColor(red: 1, green: 200 / 255, blue: 51 / 255, alpha: 1)
        view.settings.fillMode = .full
        view.settings.starMargin = Double(16.scale)
        view.settings.starSize = Double(32.scale)
        view.settings.disablePanGestures = true
        view.didFinishTouchingCosmos = { [weak self] rating in
            self?.element.rating = Int(rating)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
