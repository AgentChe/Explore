//
//  JADetailsView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 12.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import Cosmos

final class JADetailsView: UIView {
    lazy var menuView = makeJADetailsMenu()
    lazy var photosSlider = makePhotosSlider()
    lazy var scrollView = makeScrollView()
    lazy var titleLabel = makeLabel()
    lazy var ratingView = makeRatingView()
    lazy var descriptionLabel = makeLabel()
    lazy var tagsTitleLabel = makeLabel()
    lazy var tagsLabel = makeLabel()
    lazy var dateLabel = makeLabel()
    lazy var tripTimeLabel = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension JADetailsView {
    func setup(articleDetails: JournalArticleDetails) {
        photosSlider.setup(urls: articleDetails
                            .thumbsImages
                            .compactMap { URL(string: $0.url) })
        
        titleLabel.attributedText = articleDetails.title
            .attributed(with: TextAttributes()
                            .textColor(UIColor.white)
                            .font(Font.Poppins.bold(size: 18.scale))
                            .lineHeight(27.scale)
                            .textAlignment(.left)
                            .letterSpacing(0.5.scale))
        
        ratingView.rating = Double(articleDetails.rating)
        
        descriptionLabel.attributedText = articleDetails.description
            .attributed(with: TextAttributes()
                            .textColor(UIColor.white)
                            .font(Font.Poppins.regular(size: 13.scale))
                            .lineHeight(24.3.scale)
                            .textAlignment(.left)
                            .letterSpacing(0.5.scale))
        
        tagsTitleLabel.attributedText = "JADetails.Tags".localized
            .attributed(with: TextAttributes()
                            .textColor(UIColor.white)
                            .font(Font.Poppins.regular(size: 14.scale))
                            .lineHeight(25.2.scale)
                            .textAlignment(.left)
                            .letterSpacing(0.5.scale))
        
        tagsLabel.attributedText  = articleDetails.tags
            .map { String(format: "#%@", $0.name) }
            .joined(separator: ", ")
            .attributed(with: TextAttributes()
                            .textColor(UIColor(red: 144 / 255, green: 152 / 255, blue: 177 / 255, alpha: 1))
                            .font(Font.Poppins.regular(size: 12.scale))
                            .lineHeight(21.6.scale)
                            .textAlignment(NSTextAlignment.right)
                            .letterSpacing(0.5.scale))
        
        let bottomAttrs = TextAttributes()
            .textColor(UIColor(red: 144 / 255, green: 152 / 255, blue: 177 / 255, alpha: 1))
            .font(Font.Poppins.regular(size: 12.scale))
            .lineHeight(21.6.scale)
            .letterSpacing(0.5.scale)
            .textAlignment(.left)
        
        dateLabel.attributedText = date(from: articleDetails).attributed(with: bottomAttrs)
        tripTimeLabel.attributedText = tripTime(from: articleDetails).attributed(with: bottomAttrs)
    }
}

// MARK: Private
private extension JADetailsView {
    func configure() {
        backgroundColor = UIColor.black
    }
    
    func date(from element: JournalArticleDetails) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ssssssZ"
        guard let date = dateFormatter.date(from: element.dateTime) else {
            return ""
        }
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
    
    func tripTime(from element: JournalArticleDetails) -> String {
        var time = ""
        
        let hours = element.tripTime / 3600
        if hours > 0 {
            time += String(format: " %i %@", hours,
                           String.choosePluralForm(byNumber: hours,
                                                   one: "Journal.Hour".localized,
                                                   two: "Journal.Hours".localized,
                                                   many: "Journal.Hours".localized))
        }
        
        let minutes = element.tripTime % 3600
        if minutes > 0 {
            time += String(format: " %i %@", hours, "Journal.Minute".localized)
        }
        
        return String(format: "JADetails.TripTime".localized, time)
    }
}

// MARK: Make constraints
private extension JADetailsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            photosSlider.leadingAnchor.constraint(equalTo: leadingAnchor),
            photosSlider.trailingAnchor.constraint(equalTo: trailingAnchor),
            photosSlider.topAnchor.constraint(equalTo: topAnchor, constant: 122.scale),
            photosSlider.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 313.scale : 263.scale)
        ])
        
        NSLayoutConstraint.activate([
            menuView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            menuView.topAnchor.constraint(equalTo: topAnchor, constant: 100.scale),
            menuView.widthAnchor.constraint(greaterThanOrEqualToConstant: 154.scale)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 377.scale : 327.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            ratingView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            ratingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.scale)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            descriptionLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            tagsTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            tagsTitleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            tagsTitleLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            tagsLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 200.scale),
            tagsLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            tagsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            dateLabel.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: 32.scale),
            dateLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -45.scale)
        ])
        
        NSLayoutConstraint.activate([
            tripTimeLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            tripTimeLabel.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: 32.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension JADetailsView {
    func makeJADetailsMenu() -> JADetailsMenu {
        let view = JADetailsMenu()
        view.isHidden = true
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = 8.scale
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePhotosSlider() -> JSDetailsPhotosSlider {
        let view = JSDetailsPhotosSlider()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.black
        view.showsVerticalScrollIndicator = false
        view.layer.cornerRadius = 27.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.textColor = .white
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeRatingView() -> CosmosView {
        let view = CosmosView()
        view.settings.totalStars = 5
        view.settings.emptyColor = UIColor(red: 235 / 255, green: 240 / 255, blue: 1, alpha: 1)
        view.settings.filledColor = UIColor(red: 1, green: 200 / 255, blue: 51 / 255, alpha: 1)
        view.settings.fillMode = .full
        view.settings.starMargin = Double(4.scale)
        view.settings.starSize = Double(16.scale)
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
}
