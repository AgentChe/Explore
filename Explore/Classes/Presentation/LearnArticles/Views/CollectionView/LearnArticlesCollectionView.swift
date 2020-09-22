//
//  LearnArticlesCollectionView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 22.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class LearnArticlesCollectionView: UICollectionView {
    weak var actionsDelegate: LearnArticlesCollectionViewDelegate?
    
    private var models = [LearnArticlesCollectionModel]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API

extension LearnArticlesCollectionView {
    func setup(models: [LearnArticlesCollectionModel]) {
        self.models = models
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource

extension LearnArticlesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch models[indexPath.row] {
        case .title(let title):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: LearnArticlesCollectionTitleCell.self), for: indexPath) as! LearnArticlesCollectionTitleCell
            cell.setup(title: title)
            return cell
        case .article(let article):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: LearnArticlesCollectionArticleCell.self), for: indexPath) as! LearnArticlesCollectionArticleCell
            cell.setup(article: article)
            return cell
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension LearnArticlesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch models[indexPath.row] {
        case .title:
            return CGSize(width: frame.width, height: 41.scale)
        case .article:
            return CGSize(width: frame.width, height: 85.scale)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard case let .article(article) = models[indexPath.row] else {
            return
        }
        
        actionsDelegate?.learnArticlesCollectionViewDidSelect(article: article)
    }
}

// MARK: Private

private extension LearnArticlesCollectionView {
    func setup() {
        register(LearnArticlesCollectionTitleCell.self, forCellWithReuseIdentifier: String(describing: LearnArticlesCollectionTitleCell.self))
        register(LearnArticlesCollectionArticleCell.self, forCellWithReuseIdentifier: String(describing: LearnArticlesCollectionArticleCell.self))
        
        dataSource = self
        delegate = self
    }
}
