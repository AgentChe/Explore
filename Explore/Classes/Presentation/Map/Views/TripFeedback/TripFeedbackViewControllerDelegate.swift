//
//  TripFeedbackViewControllerDelegate.swift
//  Explore
//
//  Created by Andrey Chernyshev on 29.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol TripFeedbackViewControllerDelegate: class {
    func tripFeedbackControllerDidCancelTapped()
    func tripFeedbackControllerDidSendTapped(text: String)
}

extension TripFeedbackViewControllerDelegate {
    func tripFeedbackControllerDidCancelTapped() {}
    func tripFeedbackControllerDidSendTapped(text: String) {}
}
