//
//  LearnContentViewController.swift
//  Explore
//
//  Created by Andrey Chernyshev on 22.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class LearnContentViewController: UIViewController {
    var learnContentView = LearnContentView()
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = LearnContentViewModel()
    
    private let articleId: Int
    
    private init(articleId: Int) {
        self.articleId = articleId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = learnContentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        learnContentView.tableView.actionsDelegate = self 
        
        viewModel
            .getContent(with: articleId)
            .drive(onNext: { [weak self] models in
                self?.learnContentView.tableView.setup(models: models)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .activityIndicator
            .drive(learnContentView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}

// MARK: Make

extension LearnContentViewController {
    static func make(articleId: Int) -> LearnContentViewController {
        let vc = LearnContentViewController(articleId: articleId)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: LearnContentTableViewDelegate

extension LearnContentViewController: LearnContentTableViewDelegate {
    func learnContentTableViewDidCloseTapped() {
        dismiss(animated: true)
    }
}
