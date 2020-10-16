//
//  FPWhatYourSearchIntentCell.swift
//  Explore
//
//  Created by Andrey Chernyshev on 16.10.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class FPWhatYourSearchIntentCell: UITableViewCell {
    enum Tag: Int {
        case void = 0
        case anomaly = 1
        case treasure = 2
        case beauty = 3
        case peace = 4
        case somethingElse = 5
        case whatThis = 6
    }
    
    weak var delegate: FindPlaceTableDelegate?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var voidButton = makeButton(title: "FindPlace.FPWhatYourSearchIntentCell.Void".localized, tag: .void)
    lazy var anomalyButton = makeButton(title: "FindPlace.FPWhatYourSearchIntentCell.Anomaly".localized, tag: .anomaly)
    lazy var treasureButton = makeButton(title: "FindPlace.FPWhatYourSearchIntentCell.Treasure".localized, tag: .treasure)
    lazy var beautyButton = makeButton(title: "FindPlace.FPWhatYourSearchIntentCell.Beauty".localized, tag: .beauty)
    lazy var peaceButton = makeButton(title: "FindPlace.FPWhatYourSearchIntentCell.Peace".localized, tag: .peace)
    lazy var somethingElseButton = makeButton(title: "FindPlace.FPWhatYourSearchIntentCell.SomethingElse".localized, tag: .somethingElse)
    lazy var whatThisButton = makeButton(title: "FindPlace.FPWhatYourSearchIntentCell.WhatThis".localized, tag: .whatThis)
    
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
        
        let views = [voidButton, anomalyButton, treasureButton, beautyButton, peaceButton, somethingElseButton, whatThisButton]
        
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
private extension FPWhatYourSearchIntentCell {
    @objc
    func buttonTapped(sender: UIButton) {
        guard let tag = Tag(rawValue: sender.tag) else {
            return
        }
        
        delegate?.findPlaceTableDidSelected(whatYourSearchIntent: tag)
    }
}

// MARK: Make constraints
private extension FPWhatYourSearchIntentCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            voidButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            voidButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 28.scale),
            voidButton.heightAnchor.constraint(equalToConstant: 48.scale),
            voidButton.widthAnchor.constraint(equalToConstant: 73.scale)
        ])
        
        NSLayoutConstraint.activate([
            anomalyButton.leadingAnchor.constraint(equalTo: voidButton.trailingAnchor, constant: 8.scale),
            anomalyButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 28.scale),
            anomalyButton.heightAnchor.constraint(equalToConstant: 48.scale),
            anomalyButton.widthAnchor.constraint(equalToConstant: 90.scale)
        ])
        
        NSLayoutConstraint.activate([
            treasureButton.leadingAnchor.constraint(equalTo: anomalyButton.trailingAnchor, constant: 8.scale),
            treasureButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 28.scale),
            treasureButton.heightAnchor.constraint(equalToConstant: 48.scale),
            treasureButton.widthAnchor.constraint(equalToConstant: 95.scale)
        ])
        
        NSLayoutConstraint.activate([
            beautyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            beautyButton.topAnchor.constraint(equalTo: voidButton.bottomAnchor, constant: 8.scale),
            beautyButton.heightAnchor.constraint(equalToConstant: 48.scale),
            beautyButton.widthAnchor.constraint(equalToConstant: 78.scale)
        ])
        
        NSLayoutConstraint.activate([
            peaceButton.leadingAnchor.constraint(equalTo: beautyButton.trailingAnchor, constant: 8.scale),
            peaceButton.topAnchor.constraint(equalTo: voidButton.bottomAnchor, constant: 8.scale),
            peaceButton.heightAnchor.constraint(equalToConstant: 48.scale),
            peaceButton.widthAnchor.constraint(equalToConstant: 78.scale)
        ])
        
        NSLayoutConstraint.activate([
            whatThisButton.leadingAnchor.constraint(equalTo: peaceButton.trailingAnchor, constant: 8.scale),
            whatThisButton.topAnchor.constraint(equalTo: voidButton.bottomAnchor, constant: 8.scale),
            whatThisButton.heightAnchor.constraint(equalToConstant: 48.scale),
            whatThisButton.widthAnchor.constraint(equalToConstant: 115.scale)
        ])
        
        NSLayoutConstraint.activate([
            somethingElseButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            somethingElseButton.topAnchor.constraint(equalTo: beautyButton.bottomAnchor, constant: 8.scale),
            somethingElseButton.heightAnchor.constraint(equalToConstant: 48.scale),
            somethingElseButton.widthAnchor.constraint(equalToConstant: 145.scale),
            somethingElseButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension FPWhatYourSearchIntentCell {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.SFProText.bold(size: 22.scale)
        view.textColor = UIColor.white
        view.numberOfLines = 0
        view.textAlignment = .left
        view.text = "FindPlace.FPWhatYourSearchIntentCell.Title".localized
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
