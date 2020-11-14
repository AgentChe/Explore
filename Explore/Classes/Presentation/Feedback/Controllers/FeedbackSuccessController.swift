//
//  FeedbackSuccessController.swift
//  Explore
//
//  Created by Andrey Chernyshev on 14.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class FeedbackSuccessController: UIViewController {
    var mainView = FeedbackSuccessView()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
}

// MARK: Make
extension FeedbackSuccessController {
    static func make() -> FeedbackSuccessController {
        let vc = FeedbackSuccessController()
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}
