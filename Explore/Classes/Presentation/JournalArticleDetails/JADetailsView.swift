//
//  JADetailsView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 12.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class JADetailsView: UIView {
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
extension JADetailsView {
    func configure() {
        backgroundColor = UIColor.black
    }
}

// MARK: Make constraints
extension JADetailsView {
    func makeConstraints() {
        
    }
}

// MARK: Lazy initialization
extension JADetailsView {
}
