//
//  TripFeedbackView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 29.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class TripFeedbackView: UIView {
    lazy var container = makeContainer()
    lazy var separator = makeSeparator()
    lazy var titleLabel = makeTitleLabel()
    lazy var textView = makeTextView()
    lazy var sendButton = makeSendButton()
    lazy var cancelButton = makeCancelButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

private extension TripFeedbackView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            container.topAnchor.constraint(equalTo: topAnchor, constant: 150.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            separator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.scale),
            separator.heightAnchor.constraint(equalToConstant: 1.scale)
        ])
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            textView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            textView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 8.scale),
            textView.heightAnchor.constraint(equalToConstant: 78.scale)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            cancelButton.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 48.scale),
            cancelButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16.scale),
            cancelButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16.scale),
            cancelButton.widthAnchor.constraint(equalTo: sendButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            sendButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor),
            sendButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            sendButton.heightAnchor.constraint(equalToConstant: 48.scale),
            sendButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16.scale),
            sendButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension TripFeedbackView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 16.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor.black
        view.font = Font.OpenSans.semibold(size: 19.scale)
        view.text = "Map.TripFeedbackViewController.Title".localized
        view.textAlignment = .center
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeTextView() -> UITextView {
        let view = UITextView()
        view.textColor = UIColor.black
        view.font = Font.OpenSans.regular(size: 15.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeSendButton() -> UIButton {
        let view = UIButton()
        view.setTitle("Send".localized, for: .normal)
        view.setTitleColor(UIColor.black, for: .normal)
        view.titleLabel?.font = Font.OpenSans.bold(size: 17.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeCancelButton() -> UIButton {
        let view = UIButton()
        view.setTitle("Cancel".localized, for: .normal)
        view.setTitleColor(UIColor.black, for: .normal)
        view.titleLabel?.font = Font.OpenSans.bold(size: 17.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
