//
//  JournalView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 11.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class JournalView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
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
