//
//  LearnViewController.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class LearnCategoriesViewController: UIViewController {
    weak var delegate: LearnCategoriesViewControllerDelegate?
    
    var learnCategoriesView = LearnCategoriesView()
    
    private let viewModel = LearnCategoriesViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = learnCategoriesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        learnCategoriesView.collectionView.actionsDelegate = self
        
        viewModel
            .needPayment
            .emit(onNext: { [weak self] in
                self?.delegate?.learnCategoriesViewControllerNeedPayment()
            })
            .disposed(by: disposeBag)
        
        viewModel
            .elements
            .drive(onNext: { [weak self] elements in
                self?.learnCategoriesView.collectionView.setup(elements: elements)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make

extension LearnCategoriesViewController {
    static func make() -> LearnCategoriesViewController {
        LearnCategoriesViewController()
    }
}

// MARK: LearnCollectionViewDelegate

extension LearnCategoriesViewController: LearnCollectionViewDelegate {
    func learnCollectionViewDidSelect(category: LearnCategory) {
        guard !category.articles.isEmpty else {
            return
        }
        
        let vc = LearnArticlesViewController.make(category: category)
        navigationController?.pushViewController(vc, animated: true)
    }
}
