//
//  AppStateManagerDelegate.swift
//  Explore
//
//  Created by Andrey Chernyshev on 30.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol AppStateManagerDelegate: class {
    func appStateManagerWillResignApplication()
    func appStateManagerDidBecomeApplication()
}
