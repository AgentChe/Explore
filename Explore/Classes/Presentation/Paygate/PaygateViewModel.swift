//
//  PaygateViewModel.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 08.07.2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift
import RxCocoa

final class PaygateViewModel {
    let buy = PublishRelay<String>()
    let restore = PublishRelay<String>()

    lazy var buyed = createBuyed()
    lazy var restored = createRestored()
    
    let buyProcessing = RxActivityIndicator()
    let restoreProcessing = RxActivityIndicator()
    let retrieveCompleted = BehaviorRelay<Bool>(value: false)
    
    private let paygateManager = PaygateManagerCore()
    private let purchaseManager = PurchaseManager()
}

// MARK: Get paygate content

extension PaygateViewModel {
    func retrieve() -> Driver<(Paygate?, Bool)> {
        let paygate = paygateManager
            .retrievePaygate()
            .asDriver(onErrorJustReturn: nil)
        
        let prices = paygate
            .flatMapLatest { [paygateManager] response -> Driver<PaygateMapper.PaygateResponse?> in
                guard let response = response else {
                    return .deferred { .just(nil) }
                }
                
                return paygateManager
                    .prepareProductsPrices(for: response)
                    .asDriver(onErrorJustReturn: nil)
            }
        
        return Driver
            .merge([paygate.map { ($0?.paygate, false) },
                    prices.map { ($0?.paygate, true) }])
            .do(onNext: { [weak self] stub in
                self?.retrieveCompleted.accept(stub.1)
            })
    }
}

// MARK: Make purchase

private extension PaygateViewModel {
    func createBuyed() -> Signal<Bool> {
        let purchase = buy
            .flatMapLatest { [purchaseManager, buyProcessing] productId -> Observable<Bool> in
                purchaseManager
                    .buySubscription(productId: productId)
                    .flatMap { purchaseManager.paymentValidate() }
                    .map { $0 != nil }
                    .trackActivity(buyProcessing)
                    .catchErrorJustReturn(false)
            }
        
        return purchase
            .asSignal(onErrorJustReturn: false)
    }
    
    func createRestored() -> Signal<Bool> {
        let purchase = restore
            .flatMapLatest { [purchaseManager, restoreProcessing] productId -> Observable<Bool> in
                purchaseManager
                    .restoreSubscription(productId: productId)
                    .flatMap { purchaseManager.paymentValidate() }
                    .map { $0 != nil }
                    .trackActivity(restoreProcessing)
                    .catchErrorJustReturn(false)
            }
        
        return purchase
            .asSignal(onErrorJustReturn: false)
    }
}
