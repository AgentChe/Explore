//
//  FPTableRadiusBundle.swift
//  Explore
//
//  Created by Andrey Chernyshev on 02.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct FPTableRadiusBundle {
    private(set) var radius: Int
    private(set) var applied: Bool
    
    mutating func setDefault() {
        self.radius = 2000
        self.applied = false
    }
    
    mutating func setRadius(_ radius: Int) {
        self.radius = radius
    }
    
    mutating func setApplied(_ applied: Bool) {
        self.applied = applied
    }
}

// MARK: Make

extension FPTableRadiusBundle {
    init() {
        radius = 2000
        applied = false
    }
}
