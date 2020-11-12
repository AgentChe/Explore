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
    
    weak var delegate: JournalViewControllerDelegate?
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = JournalViewModel()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonState = viewModel.buttonState()
        
        let content = viewModel.content()
        
        content
            .drive(onNext: { [weak self] content in
                switch content {
                case .needPayment:
                    self?.delegate?.journalViewControllerNeedPayment()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        let articles = content
            .compactMap { content -> [JournalArticle]? in
                guard case let .articles(list) = content else {
                    return nil
                }
            
                return list
            }
        
        articles
            .drive(onNext: mainView.tableView.setup(elements:))
            .disposed(by: disposeBag)
        
        articles
            .map { !$0.isEmpty }
            .drive(mainView.emptyView.rx.isHidden)
            .disposed(by: disposeBag)
        
        articles
            .map { $0.isEmpty }
            .drive(mainView.tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        buttonState
            .drive(onNext: updateButton(state:))
            .disposed(by: disposeBag)
        
        mainView
            .button.rx.tap
            .withLatestFrom(buttonState)
            .subscribe(onNext: handleButtonTap(with:))
            .disposed(by: disposeBag)
        
        mainView
            .tableView
            .tapped
            .subscribe(onNext: goToDetails(with:))
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension JournalViewController {
    static func make() -> JournalViewController {
        JournalViewController()
    }
}

// MARK: FindPlaceViewControllerDelegate
extension JournalViewController: FindPlaceViewControllerDelegate {
    func findPlaceViewControllerTripCreated() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: Private
private extension JournalViewController {
    func updateButton(state: JournalViewModel.ButtonState) {
        let attrs = TextAttributes()
            .textColor(UIColor(red: 21 / 255, green: 21 / 255, blue: 34 / 255, alpha: 1))
            .font(Font.Poppins.semibold(size: 16.scale))
            .lineHeight(22.scale)
        
        switch state {
        case .feedback:
            mainView.button.isHidden = false
            
            mainView.button.setAttributedTitle("Journal.FeedbackButton".localized.attributed(with: attrs), for: .normal)
        case .newEntry:
            mainView.button.isHidden = false
            
            mainView.button.setAttributedTitle("Journal.NewEntryButton".localized.attributed(with: attrs), for: .normal)
        case .hidden:
            mainView.button.isHidden = true
        }
    }
    
    func handleButtonTap(with state: JournalViewModel.ButtonState) {
        switch state {
        case .feedback:
            guard let tripId = viewModel.getTrip()?.id else {
                return
            }
            
            let vc = FeedbackViewController.make(tripId: tripId)
            
            navigationController?.pushViewController(vc, animated: true)
        case .newEntry:
            let vc = FindPlaceViewController.make()
            vc.delegate = self
            
            navigationController?.pushViewController(vc, animated: true)
        case .hidden:
            break
        }
    }
    
    func goToDetails(with article: JournalArticle) {
        
    }
}
