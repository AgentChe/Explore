//
//  LearnCollectionViewDelegate.swift
//  Explore
//
//  Created by Andrey Chernyshev on 22.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol LearnCollectionViewDelegate: class {
    func learnCollectionViewDidSelect(category: LearnCategory)
}

extension LearnCollectionViewDelegate {
    func learnCollectionViewDidSelect(category: LearnCategory) {}
}
