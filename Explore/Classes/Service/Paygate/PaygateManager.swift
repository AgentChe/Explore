//
//  PaygateManager.swift
//  Explore
//
//  Created by Andrey Chernyshev on 26.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift

final class PaygateManager {}

// MARK: Retrieve

extension PaygateManager {
    func retrievePaygate() -> Single<PaygateMapper.PaygateResponse?> {
        RestAPITransport()
            .callServerApi(requestBody: GetPaygateRequest(userToken: SessionManager.shared.getSession()?.userToken,
                                                          locale: UIDevice.deviceLanguageCode ?? "en",
                                                          version: UIDevice.appVersion ?? "1",
                                                          appKey: IDFAService.shared.getAppKey()))
            .map { PaygateMapper.parse(response: $0, productsPrices: nil) }
    }
}

// MARK: Prepare prices

extension PaygateManager {
    static func prepareProductsPrices(for paygate: PaygateMapper.PaygateResponse) -> Single<PaygateMapper.PaygateResponse?> {
        guard !paygate.productsIds.isEmpty else {
            return .deferred { .just(paygate) }
        }
        
        return PurchaseManager
            .productsPrices(ids: paygate.productsIds)
            .map { PaygateMapper.parse(response: paygate.json, productsPrices: $0.retrievedPrices) }
    }
}
