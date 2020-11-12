//
//  JADetailsViewController.swift
//  Explore
//
//  Created by Andrey Chernyshev on 12.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class JADetailsViewController: UIViewController {
    var mainView = JADetailsView()
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = JADetailsViewModel()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
}

// MARK: Make
extension JADetailsViewController {
    static func make(articleId: Int) -> JADetailsViewController {
        JADetailsViewController()
    }
    
    static func make(artricle: JournalArticle) -> JADetailsViewController {
        JADetailsViewController()
    }
}
