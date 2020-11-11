//
//  JournalViewController.swift
//  Explore
//
//  Created by Andrey Chernyshev on 11.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class JournalViewController: UIViewController {
    var mainView = JournalView()
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = JournalViewModel()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
}

// MARK: Make
extension JournalViewController {
    static func make() -> JournalViewController {
        JournalViewController()
    }
}
