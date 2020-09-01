//
//  FPWhatLikeGetCell.swift
//  Explore
//
//  Created by Andrey Chernyshev on 31.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class FPWhatLikeGetCell: UITableViewCell {
    enum Tag: Int {
        case anomaly = 0
        case attractor = 1
        case void = 2
        case pseudo = 3
        case whatItIs = 4
    }
    
    weak var delegate: FindPlaceTableDelegate?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var anomalyButton = makeButton(title: "FindPlace.FPWhatLikeGetCell.Anomaly".localized, tag: .anomaly)
    lazy var attractorButton = makeButton(title: "FindPlace.FPWhatLikeGetCell.Attractor".localized, tag: .attractor)
    lazy var voidButton = makeButton(title: "FindPlace.FPWhatLikeGetCell.Void".localized, tag: .void)
    lazy var pseudoButton = makeButton(title: "FindPlace.FPWhatLikeGetCell.Pseudo".localized, tag: .pseudo)
    lazy var whatItIsButton = makeButton(title: "FindPlace.FPWhatLikeGetCell.WhatItIs".localized, tag: .whatItIs)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(selectedTag: Tag?) {
        let selectedColor = UIColor.white.withAlphaComponent(0.9)
        let unselectedColor = UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 0.2)
        
        let views = [anomalyButton, attractorButton, voidButton, pseudoButton, whatItIsButton]
        
        guard let tag = selectedTag?.rawValue else {
            views.forEach {
                $0.backgroundColor = selectedColor
            }
            
            return
        }
        
        views.forEach {
            $0.backgroundColor = $0.tag == tag ? selectedColor : unselectedColor
        }
    }
}

// MARK: Private

private extension FPWhatLikeGetCell {
    @objc
    func buttonTapped(sender: UIButton) {
        guard let tag = Tag(rawValue: sender.tag) else {
            return
        }
        
        delegate?.findPlaceTableDidSelected(whatLikeGet: tag)
    }
}

// MARK: Make constraints

private extension FPWhatLikeGetCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            anomalyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            anomalyButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 28.scale),
            anomalyButton.heightAnchor.constraint(equalToConstant: 48.scale),
            anomalyButton.widthAnchor.constraint(equalToConstant: 109.scale)
        ])
        
        NSLayoutConstraint.activate([
            attractorButton.leadingAnchor.constraint(equalTo: anomalyButton.trailingAnchor, constant: 8.scale),
            attractorButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 28.scale),
            attractorButton.heightAnchor.constraint(equalToConstant: 48.scale),
            attractorButton.widthAnchor.constraint(equalToConstant: 112.scale)
        ])
        
        NSLayoutConstraint.activate([
            voidButton.leadingAnchor.constraint(equalTo: attractorButton.trailingAnchor, constant: 8.scale),
            voidButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 28.scale),
            voidButton.heightAnchor.constraint(equalToConstant: 48.scale),
            voidButton.widthAnchor.constraint(equalToConstant: 73.scale)
        ])
        
        NSLayoutConstraint.activate([
            pseudoButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            pseudoButton.topAnchor.constraint(equalTo: anomalyButton.bottomAnchor, constant: 8.scale),
            pseudoButton.heightAnchor.constraint(equalToConstant: 48.scale),
            pseudoButton.widthAnchor.constraint(equalToConstant: 98.scale),
            pseudoButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            whatItIsButton.leadingAnchor.constraint(equalTo: pseudoButton.trailingAnchor, constant: 8.scale),
            whatItIsButton.topAnchor.constraint(equalTo: anomalyButton.bottomAnchor, constant: 8.scale),
            whatItIsButton.heightAnchor.constraint(equalToConstant: 48.scale),
            whatItIsButton.widthAnchor.constraint(equalToConstant: 122.scale),
            whatItIsButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension FPWhatLikeGetCell {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.SFProText.bold(size: 22.scale)
        view.textColor = UIColor.white
        view.numberOfLines = 0
        view.textAlignment = .left
        view.text = "FindPlace.FPWhatLikeGetCell.Title".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeButton(title: String, tag: Tag) -> UIButton {
        let view = UIButton()
        view.tag = tag.rawValue
        view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        view.layer.cornerRadius = 16.scale
        view.setTitleColor(UIColor.black, for: .normal)
        view.setTitle(title, for: .normal)
        view.titleLabel?.font = Font.SFCompactText.regular(size: 18.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
}
