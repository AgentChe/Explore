//
//  FeedbackViewController.swift
//  Explore
//
//  Created by Andrey Chernyshev on 11.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class FeedbackViewController: UIViewController {
    var mainView = FeedbackView()
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = FeedbackViewModel()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
}

// MARK: Make
extension FeedbackViewController {
    static func make(tripId: Int) -> FeedbackViewController {
        FeedbackViewController()
    }
    
    static func make(articleDetails: JournalArticleDetails) -> FeedbackViewController {
        FeedbackViewController()
    }
    
    static func make(article: JournalArticle) -> FeedbackViewController {
        FeedbackViewController()
    }
}
