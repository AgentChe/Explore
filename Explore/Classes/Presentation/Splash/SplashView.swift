//
//  SplashView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 07.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class SplashView: UIView {
    lazy var label = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

private extension SplashView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension SplashView {
    func makeLabel() -> UILabel {
        let view =  UILabel()
        view.textColor = UIColor.white
        view.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        view.text = "Explore"
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
