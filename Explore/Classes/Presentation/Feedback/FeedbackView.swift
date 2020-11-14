//
//  FeedbackView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 11.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class FeedbackView: UIView {
    lazy var tableView = makeTableView()
    lazy var button = makeButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension FeedbackView {
    func configure() {
        backgroundColor = UIColor.black
    }
}

// MARK: Make constraints
private extension FeedbackView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 90.scale),
            tableView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -18.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            button.heightAnchor.constraint(equalToConstant: 50.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -39.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension FeedbackView {
    func makeTableView() -> FeedbackTableView {
        let view = FeedbackTableView()
        view.backgroundColor = UIColor.clear
        view.separatorStyle = .none
        view.allowsSelection = false
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor(red: 21 / 255, green: 21 / 255, blue: 34 / 255, alpha: 1))
            .font(Font.Poppins.semibold(size: 16.scale))
            .lineHeight(22.scale)
        
        let view = UIButton()
        view.backgroundColor = UIColor.white
        view.setAttributedTitle("Feedback.Save".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 25.scale
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = UIColor(red: 223 / 255, green: 86 / 255, blue: 21 / 255, alpha: 1).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
