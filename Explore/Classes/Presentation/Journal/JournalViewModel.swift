//
//  JournalViewModel.swift
//  Explore
//
//  Created by Andrey Chernyshev on 11.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class JournalViewModel {
    enum ButtonState {
        case feedback, newEntry, hidden
    }
    
    
    enum Content {
        case articles([JournalArticle])
        case needPayment
    }
    
    private let tripManager: TripManager = TripManagerMock()
    private let journalManager: JournalManager = JournalManagerMock()
    
    func buttonState() -> Driver<ButtonState> {
        createButtonState()
    }
    
    func content() -> Driver<Content> {
        createContent()
    }
    
    func getTrip() -> Trip? {
        tripManager.getTrip()
    }
}

// MARK: Private
private extension JournalViewModel {
    func createButtonState() -> Driver<ButtonState> {
        let inProgress = Driver<Bool>
            .merge([
                tripManager
                    .rxIsTripInProgress()
                    .asDriver(onErrorDriveWith: .empty()),
                
                TripMediator.shared
                    .rxChangedProgressState
                    .asDriver(onErrorDriveWith: .empty())
            ])
        
        let hasTrip = Driver<Bool>
            .merge([
                tripManager
                    .rxHasTrip()
                    .asDriver(onErrorDriveWith: .empty()),
                
                TripMediator.shared
                    .rxTripWasRemovedTrigger
                    .map { false }
                    .asDriver(onErrorDriveWith: .empty())
            ])
        
        return Driver
            .combineLatest(inProgress, hasTrip)
            .map { inProgress, hasTrip -> ButtonState in
                guard hasTrip else {
                    return .newEntry
                }
                
                if inProgress {
                    return .feedback
                }
                
                return .hidden
            }
    }
    
    func createContent() -> Driver<Content> {
        Driver<Content>
            .merge([
                journalManager
                    .rxRetrieveArticles(forceUpdate: true)
                    .map { Content.articles($0) }
                    .asDriver(onErrorRecover: { error -> Driver<Content> in
                        if ErrorChecker.needPayment(in: error) {
                            return .just(.needPayment)
                        }
                        
                        return .empty()
                    }),
                
                journalManager
                    .rxDidStoredArticles
                    .map { Content.articles($0) }
                    .asDriver(onErrorDriveWith: .empty()),
                
                journalManager
                    .rxDidRemovedArticleId
                    .flatMapLatest { [weak self] removedId -> Driver<Content> in
                        guard let this = self else {
                            return .empty()
                        }
                        
                        return this.journalManager
                            .rxRetrieveArticles(forceUpdate: false)
                            .map { Content.articles($0) }
                            .asDriver(onErrorDriveWith: .empty())
                    }
            ])
    }
}
