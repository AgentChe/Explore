//
//  JournalTableCell.swift
//  Explore
//
//  Created by Andrey Chernyshev on 11.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import Cosmos

final class JournalTableCell: UITableViewCell {
    lazy var titleLabel = makeLabel()
    lazy var ratingView = makeRatingView()
    lazy var descriptionLabel = makeLabel()
    lazy var tagsLabel = makeLabel()
    lazy var dateLabel = makeLabel()
    lazy var tripTimeLabel = makeLabel()
    
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
extension JournalTableCell {
    func setup(element: JournalArticle) {
        titleLabel.attributedText = element.title
            .attributed(with: TextAttributes()
                            .textColor(UIColor.white)
                            .font(Font.Poppins.bold(size: 12.scale))
                            .lineHeight(21.scale)
                            .textAlignment(.left)
                            .letterSpacing(0.5.scale))
        
        ratingView.rating = Double(element.rating)
        
        descriptionLabel.attributedText = element.description
            .attributed(with: TextAttributes()
                            .textColor(UIColor.white)
                            .font(Font.Poppins.regular(size: 14.scale))
                            .lineHeight(21.6.scale)
                            .textAlignment(.left)
                            .letterSpacing(0.5.scale))
        
        tagsLabel.attributedText  = element.tags
            .map { String(format: "#%@", $0.name) }
            .joined(separator: ", ")
            .attributed(with: TextAttributes()
                            .textColor(UIColor(red: 242 / 255, green: 242 / 255, blue: 242 / 255, alpha: 1))
                            .font(Font.Poppins.regular(size: 10.scale))
                            .lineHeight(15.scale)
                            .textAlignment(.left)
                            .letterSpacing(0.5.scale))
        
        let bottomAttrs = TextAttributes()
            .textColor(UIColor(red: 144 / 255, green: 152 / 255, blue: 177 / 255, alpha: 1))
            .font(Font.Poppins.regular(size: 10.scale))
            .lineHeight(15.scale)
            .letterSpacing(0.5.scale)
            .textAlignment(.left)
        
        dateLabel.attributedText = date(from: element).attributed(with: bottomAttrs)
        tripTimeLabel.attributedText = tripTime(from: element).attributed(with: bottomAttrs)
    }
}

// MARK: Private
private extension JournalTableCell {
    func configure() {
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
        
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
    }
    
    func date(from element: JournalArticle) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ssssssZ"
        guard let date = dateFormatter.date(from: element.dateTime) else {
            return ""
        }
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
    
    func tripTime(from element: JournalArticle) -> String {
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
        
        return String(format: "Journal.Cell.TripTime".localized, time)
    }
}

// MARK: Make constraints
private extension JournalTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            ratingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.scale)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 36.scale)
        ])
        
        NSLayoutConstraint.activate([
            tagsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            tagsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            tagsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            dateLabel.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: 16.scale),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tripTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            tripTimeLabel.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: 16.scale),
            tripTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension JournalTableCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
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
        view.settings.starMargin = Double(4.scale)
        view.settings.starSize = Double(16.scale)
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
