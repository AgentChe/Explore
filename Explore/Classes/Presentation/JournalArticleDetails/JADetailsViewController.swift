//
//  JADetailsViewController.swift
//  Explore
//
//  Created by Andrey Chernyshev on 12.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class JADetailsViewController: UIViewController {
    var mainView = JADetailsView()
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = JADetailsViewModel()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.menuView.isUserInteractionEnabled = true
        
        let articleDetails = viewModel.articleDetails()
        
        addMenuItem()
        addMainViewTappedAction()
        addEditAction(articleDetails: articleDetails)
        addShareAction(articleDetails: articleDetails)
        addDeleteAction()
        
        articleDetails
            .drive(onNext: { [weak self] details in
                guard let articleDetails = details else {
                    return
                }
                
                self?.mainView.setup(articleDetails: articleDetails)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .deleted()
            .drive(onNext: handleDelete(result:))
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension JADetailsViewController {
    static func make(articleId: Int) -> JADetailsViewController {
        let vc = JADetailsViewController()
        vc.viewModel.inputArticleId.accept(articleId)
        return vc
    }
    
    static func make(artricle: JournalArticle) -> JADetailsViewController {
        let vc = JADetailsViewController()
        vc.viewModel.inputArticle.accept(artricle)
        return vc
    }
}

// MARK: Private
private extension JADetailsViewController {
    func addMenuItem() {
        let item = UIBarButtonItem()
        item.image = UIImage(named: "JADetails.Menu")
        
        navigationItem.rightBarButtonItem = item
        
        item.rx.tap
            .map { false }
            .bind(to: mainView.menuView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    func addMainViewTappedAction() {
        let tapGesture = UITapGestureRecognizer()
        mainView.isUserInteractionEnabled = true
        mainView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .map { _ in true }
            .bind(to: mainView.menuView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    func addEditAction(articleDetails: Driver<JournalArticleDetails?>) {
        let tapGesture = UITapGestureRecognizer()
        mainView.menuView.editItem.isUserInteractionEnabled = true
        mainView.menuView.editItem.addGestureRecognizer(tapGesture)
    
        tapGesture.rx.event
            .withLatestFrom(articleDetails)
            .subscribe(onNext: { [weak self] articleDetails in
                guard let details = articleDetails else {
                    return
                }
                
                let vc = FeedbackViewController.make(articleDetails: details)
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func addShareAction(articleDetails: Driver<JournalArticleDetails?>) {
        let tapGesture = UITapGestureRecognizer()
        mainView.menuView.shareItem.isUserInteractionEnabled = true
        mainView.menuView.shareItem.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .withLatestFrom(articleDetails)
            .subscribe(onNext: { [weak self] details in
                guard let path = details?.sharePath, let url = URL(string: path) else {
                    return
                }
                
                let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                self?.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func addDeleteAction() {
        let tapGesture = UITapGestureRecognizer()
        mainView.menuView.deleteItem.isUserInteractionEnabled = true
        mainView.menuView.deleteItem.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] event in
                let alert = UIAlertController(title: "JADetails.DeleteAlert.Title".localized,
                                              message: "JADetails.DeleteAlert.Body".localized,
                                              preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
                alert.addAction(cancelAction)
                
                let deleteAction = UIAlertAction(title: "Delete".localized, style: .default) { _ in
                    self?.viewModel.delete.accept(Void())
                }
                alert.addAction(deleteAction)
                
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func handleDelete(result: Bool) {
        switch result {
        case true:
            navigationController?.popViewController(animated: true)
        case false:
            Toast.notify(with: "JADetails.DeleteFailure".localized, style: .danger)
        }
    }
}
