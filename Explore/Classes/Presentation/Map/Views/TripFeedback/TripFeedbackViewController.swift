//
//  TripFeedbackViewController.swift
//  Explore
//
//  Created by Andrey Chernyshev on 28.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class TripFeedbackViewController: UIViewController {
    var tripFeedbackView = TripFeedbackView()
    
    weak var delegate: TripFeedbackViewControllerDelegate?
    
    override func loadView() {
        super.loadView()
        
        view = tripFeedbackView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tripFeedbackView.cancelButton
            .addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        tripFeedbackView.sendButton
            .addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
        tripFeedbackView
            .textView
            .becomeFirstResponder()
    }
}

// MARK: Make

extension TripFeedbackViewController {
    static func make() -> TripFeedbackViewController {
        let vc = TripFeedbackViewController()
        vc.modalPresentationStyle = .overCurrentContext
        return vc
    }
}

// MARK: Private

private extension TripFeedbackViewController {
    @objc
    func cancelButtonTapped() {
        tripFeedbackView
            .textView
            .resignFirstResponder()
        
        dismiss(animated: true) { [weak self] in
            self?.delegate?.tripFeedbackControllerDidCancelTapped()
        }
    }
    
    @objc
    func sendButtonTapped() {
        guard let text = tripFeedbackView.textView.text, !text.isEmpty else {
            return
        }
        
        tripFeedbackView
            .textView
            .resignFirstResponder()
        
        dismiss(animated: true) { [weak self] in
            self?.delegate?.tripFeedbackControllerDidSendTapped(text: text)
        }
    }
}
