//
//  FindPlaceView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 27.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class FindPlaceView: UIView {
    lazy var button = makeButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .blue
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

private extension FindPlaceView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            button.heightAnchor.constraint(equalToConstant: 56.scale),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension FindPlaceView {
    func makeButton() -> UIButton {
        let view = UIButton()
        view.setTitle("Create trip", for: .normal)
        view.setTitleColor(UIColor.white, for: .normal)
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = 8.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
