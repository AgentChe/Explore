//
//  LearnArticlesCollectionViewDelegate.swift
//  Explore
//
//  Created by Andrey Chernyshev on 22.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol LearnArticlesCollectionViewDelegate: class {
    func learnArticlesCollectionViewDidSelect(article: LearnArticle)
}

extension LearnArticlesCollectionViewDelegate {
    func learnArticlesCollectionViewDidSelect(article: LearnArticle) {}
}
