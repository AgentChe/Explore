//
//  LearnViewModel.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class LearnCategoriesViewModel {
    lazy var elements = createElements()
    lazy var needPayment = createNeedPaymentSignal()
    
    private let learnManager = LearnManagerCore()
    
    private let needPaymentTrigger = PublishRelay<Void>()
}

// MARK: Private

private extension LearnCategoriesViewModel {
    func createElements() -> Driver<[LearnCategoriesCollectionElement]> {
        let cached = Driver<[LearnCategory]>
            .deferred { [weak self] in
                return .just(self?.learnManager.getCategories() ?? [])
            }
        
        let updated = learnManager
            .rxGetCategories(forceUpdate: true)
            .do(onError: { [weak self] error in
                if let paymentError = error as? PaymentError, paymentError == .needPayment {
                    self?.needPaymentTrigger.accept(Void())
                    
                    return
                }
                
                if let signError = error as? SignError, signError == .tokenNotFound {
                    self?.needPaymentTrigger.accept(Void())
                    
                    return
                }
            })
            .asDriver(onErrorJustReturn: [])
        
        return Driver<[LearnCategory]>
            .concat([cached, updated])
            .map { categories -> [LearnCategoriesCollectionElement] in
                let list: [LearnCategoriesCollectionElement] = categories.map {
                    .category($0)
                }
                
                return [.title] + list
            }
    }
    
    func createNeedPaymentSignal() -> Signal<Void> {
        needPaymentTrigger.asSignal()
    }
}
