//
//  PurchaseManager.swift
//  Explore
//
//  Created by Andrey Chernyshev on 26.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import SwiftyStoreKit

final class PurchaseManager {
    static func register() {
        SwiftyStoreKit.completeTransactions { purchases in
            for purchase in purchases {
                let state = purchase.transaction.transactionState
                if state == .purchased || state == .restored {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
        }
    }
}

// MARK: Purchase

extension PurchaseManager {
    func buySubscription(productId: String) -> Single<Void> {
        Single<Void>.create { single in
            SwiftyStoreKit.purchaseProduct(productId, quantity: 1, atomically: true) { result in
                switch result {
                case .success(_):
                    single(.success(Void()))
                case .error(_):
                    single(.error(PurchaseError.failedPurchaseProduct))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func restoreSubscription(productId: String) -> Single<Void> {
        Single<Void>.create { single in
            SwiftyStoreKit.restorePurchases(atomically: true) { result in
                if result.restoredPurchases.isEmpty {
                    single(.error(PurchaseError.nonProductsForRestore))
                } else if result.restoredPurchases.contains(where: { $0.productId == productId }) {
                    single(.success(Void()))
                } else {
                    single(.error(PurchaseError.failedRestorePurchases))
                }
            }
            
            return Disposables.create()
        }
    }
}

// MARK: Validate

extension PurchaseManager {
    func paymentValidate(receipt: String) -> Single<Session?> {
        RestAPITransport()
            .callServerApi(requestBody: PurchaseValidateRequest(userToken: SessionManager.shared.getSession()?.userToken,
                                                                receipt: receipt,
                                                                version: UIDevice.appVersion ?? "1"))
            .map { Session.parseFromDictionary(any: $0) }
            .do(onSuccess: { session in
                if let session = session {
                    SessionManager.shared.store(session: session)
                }
            })
    }
    
    func paymentValidate() -> Single<Session?> {
        receipt
            .flatMap { [weak self] receiptBase64 -> Single<Session?> in
                guard let `self` = self, let receipt = receiptBase64 else {
                    return .just(nil)
                }
                
                return self.paymentValidate(receipt: receipt)
            }
    }
}

// MARK: Price

extension PurchaseManager {
    static func productsPrices(ids: [String]) -> Single<RetrievedProductsPrices> {
        Single<RetrievedProductsPrices>.create { event in
            SwiftyStoreKit.retrieveProductsInfo(Set(ids)) { products in
                let retrieved: [ProductPrice] = products
                    .retrievedProducts
                    .compactMap { ProductPrice(product: $0) }
                
                let invalidated = products
                    .invalidProductIDs
                
                let result = RetrievedProductsPrices(retrievedPrices: retrieved, invalidatedIds: Array(invalidated))
                
                event(.success(result))
            }
            
            return Disposables.create()
        }
    }
}

// MARK: Receipt

extension PurchaseManager {
    var receipt: Single<String?> {
        Single<String?>.create { single in
            let receipt = SwiftyStoreKit.localReceiptData?.base64EncodedString()
            
            single(.success(receipt))
            
            return Disposables.create()
        }
    }
}
