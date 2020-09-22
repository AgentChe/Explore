//
//  LearnArticlesViewController.swift
//  Explore
//
//  Created by Andrey Chernyshev on 22.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class LearnArticlesViewController: UIViewController {
    var learnArticlesView = LearnArticlesView()
    
    private let viewModel = LearnArticlesViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let category: LearnCategory
    
    private init(category: LearnCategory) {
        self.category = category
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = learnArticlesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        learnArticlesView.collectionView.actionsDelegate = self 
        
        let title = LearnArticlesCollectionModel.title(category.name)
        let articles = category.articles.map { LearnArticlesCollectionModel.article($0) }
        let models = [title] + articles
        
        learnArticlesView.collectionView.setup(models: models)
    }
}

// MARK: Make

extension LearnArticlesViewController {
    static func make(category: LearnCategory) -> LearnArticlesViewController {
        LearnArticlesViewController(category: category)
    }
}

// MARK: LearnArticlesCollectionViewDelegate

extension LearnArticlesViewController: LearnArticlesCollectionViewDelegate {
    func learnArticlesCollectionViewDidSelect(article: LearnArticle) {
        let vc = LearnContentViewController.make(articleId: article.id)
        present(vc, animated: true)
    }
}
