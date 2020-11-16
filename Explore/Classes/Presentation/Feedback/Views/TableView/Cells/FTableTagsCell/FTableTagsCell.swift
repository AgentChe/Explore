//
//  FTableTagsCell.swift
//  Explore
//
//  Created by Andrey Chernyshev on 16.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class FTableTagsCell: UITableViewCell {
    lazy var titleLabel = makeTitleLabel()
    lazy var tagsView = makeTagsView()
    
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
extension FTableTagsCell {
    func setup(element: FTableElement) {
        self.element = element
        
        tagsView.removeAllTags()
        
        let selectedTags = element.selectedTags ?? []
        
        let views = element
            .tags
            .map { tag -> TagView in
                let view = TagView(journalTag: tag)
                view.textColor = UIColor.white
                view.selectedTextColor = UIColor(red: 14 / 255, green: 14 / 255, blue: 14 / 255, alpha: 1)
                view.tagBackgroundColor = UIColor.clear
                view.selectedBackgroundColor = UIColor(red: 242 / 255, green: 242 / 255, blue: 242 / 255, alpha: 1)
                view.cornerRadius = 4.scale
                view.borderWidth = 1.scale
                view.borderColor = UIColor(red: 242 / 255, green: 242 / 255, blue: 242 / 255, alpha: 1)
                view.selectedBorderColor = UIColor(red: 242 / 255, green: 242 / 255, blue: 242 / 255, alpha: 1)
                view.paddingX = 10.scale
                view.paddingY = 6.scale
                view.textFont = Font.Poppins.regular(size: 12.scale)
                view.removeIconLineWidth = 2.scale
                view.removeButtonIconSize = 8.scale
                view.removeIconLineColor = UIColor(red: 14 / 255, green: 14 / 255, blue: 14 / 255, alpha: 1)
                view.isSelected = selectedTags.contains(where: { $0.id == tag.id })
                view.enableRemoveButton = view.isSelected
                view.addTarget(self, action: #selector(handleTapped(button:)), for: .touchUpInside)
                return view
            }
        tagsView.addTagViews(views)
        tagsView.layoutIfNeeded()
    }
}

// MARK: Private
private extension FTableTagsCell {
    func configure() {
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
    
    @objc
    func handleTapped(button: UIButton) {
        guard let tagView = button as? TagView else {
            return
        }
        
        tagView.isSelected = !tagView.isSelected
        tagView.enableRemoveButton = tagView.isSelected
        
        if tagView.isSelected {
            var selectedTags = element.selectedTags ?? []
            selectedTags.append(tagView.journalTag)
            element.selectedTags = selectedTags
        } else {
            element.selectedTags?.removeAll(where: { $0.id == tagView.journalTag.id })
        }
        
        tagView.removeButton.setNeedsDisplay()
        tagView.removeButton.layoutIfNeeded()
        
        tagsView.marginY = 12.scale // call private func rearrangeViews
    }
}

// MARK: Make constraints
private extension FTableTagsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tagsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            tagsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            tagsView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.scale),
            tagsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension FTableTagsCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Font.Poppins.bold(size: 14.scale))
            .lineHeight(21.scale)
            .letterSpacing(0.5.scale)
        
        let view = UILabel()
        view.attributedText = "Feedback.TagsCell.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTagsView() -> TagListView {
        let view = TagListView()
        view.backgroundColor = UIColor.clear
        view.marginX = 12.scale
        view.marginY = 12.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
