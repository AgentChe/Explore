//
//  JournalView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 11.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class JournalView: UIView {
    lazy var tableView = makeTableView()
    lazy var emptyView = makeEmptyView()
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
private extension JournalView {
    func configure() {
        backgroundColor = UIColor.black
    }
}

// MARK: Make constraints
private extension JournalView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyView.topAnchor.constraint(equalTo: topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            button.heightAnchor.constraint(equalToConstant: 50.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension JournalView {
    func makeTableView() -> JournalTableView {
        let view = JournalTableView()
        view.separatorStyle = .none
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90.scale, right: 0)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmptyView() -> JournalEmptyView {
        let view = JournalEmptyView()
        view.backgroundColor = UIColor.clear
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 25.scale
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = UIColor(red: 223 / 255, green: 86 / 255, blue: 21 / 255, alpha: 1).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
