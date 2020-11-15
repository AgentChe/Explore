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
    enum ScreenType {
        case create, edit
    }
    
    weak var delegate: FeedbackViewControllerDelegate?
    
    var mainView = FeedbackView()
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = FeedbackViewModel()
    
    private let screenType: ScreenType
    
    private init(type: ScreenType) {
        self.screenType = type
        
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.vc = self 
        
        let element = viewModel.element()
        
        element
            .drive(onNext: mainView.tableView.setup(element:))
            .disposed(by: disposeBag)
        
        element
            .flatMap { $0.canCreateArticle.asDriver() }
            .drive(mainView.button.rx.isEnabled)
            .disposed(by: disposeBag)
        
        mainView
            .button.rx.tap
            .withLatestFrom(element)
            .flatMapLatest(viewModel.createFeedback(element:))
            .subscribe(onNext: { [weak self] success in
                switch success {
                case true:
                    self?.handleSuccessResult()
                case false:
                    Toast.notify(with: "Feedback.CreateFailure".localized, style: .danger)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel
            .createFeedbackInProgress
            .drive(onNext: { [weak self] inProgress in
                inProgress ? self?.mainView.button.startAnimation() : self?.mainView.button.stopAnimation()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Private
extension FeedbackViewController {
    func handleSuccessResult() {
        switch screenType {
        case .create:
            showCreateCompletionResult()
        case .edit:
            Toast.notify(with: "Feedback.EditSuccess".localized, style: .success)
        }
    }
    
    func showCreateCompletionResult() {
        viewModel.removeTrip()
        
        let vc = FeedbackSuccessController.make()
        
        vc.mainView
            .button.rx.tap
            .subscribe(onNext: { [weak self] in
                vc.dismiss(animated: true) {
                    self?.navigationController?.popViewController(animated: true)
                    
                    self?.delegate?.feedbackViewControllerToNewLocation()
                }
            })
            .disposed(by: disposeBag)
        
        present(vc, animated: true)
    }
}

// MARK: Make
extension FeedbackViewController {
    static func make(tripId: Int, screenType: ScreenType) -> FeedbackViewController {
        let vc = FeedbackViewController(type: screenType)
        vc.viewModel.inputTripId.accept(tripId)
        return vc
    }
    
    static func make(articleDetails: JournalArticleDetails, screenType: ScreenType) -> FeedbackViewController {
        let vc = FeedbackViewController(type: screenType)
        vc.viewModel.inputArticleDetails.accept(articleDetails)
        return vc
    }
    
    static func make(article: JournalArticle, screenType: ScreenType) -> FeedbackViewController {
        let vc = FeedbackViewController(type: screenType)
        vc.viewModel.inputArticle.accept(article)
        return vc
    }
}
