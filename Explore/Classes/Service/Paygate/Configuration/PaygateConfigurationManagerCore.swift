//
//  PaygateConfigurationManagerCore.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.10.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift

final class PaygateConfigurationManagerCore: PaygateConfigurationManager {
    struct Constants {
        static let configurationCacheKey = "paygate_configuration_manager_core_configuration_cache_key"
    }
}

// MARK: API
extension PaygateConfigurationManagerCore {
    func clearCache() {
        UserDefaults.standard.removeObject(forKey: Constants.configurationCacheKey)
    }
    
    func getConfiguration() -> PaygateConfiguration? {
        guard let data = UserDefaults.standard.data(forKey: Constants.configurationCacheKey) else {
            return nil
        }

        return try? JSONDecoder().decode(PaygateConfiguration.self, from: data)
    }
    
    func set(activeSubscription: Bool) {
        guard let cached = getConfiguration() else {
            return
        }
        
        let configuration = PaygateConfiguration(activeSubscription: activeSubscription,
                                                 onboardingPaygate: cached.onboardingPaygate,
                                                 generateSpotPaygate: cached.generateSpotPaygate,
                                                 navigateSpotPaygate: cached.navigateSpotPaygate,
                                                 learnPaygate: cached.learnPaygate,
                                                 seePaygate: cached.seePaygate)
        
        store(configuration: configuration)
    }
}

// MARK: API(Rx)
extension PaygateConfigurationManagerCore {
    func rxRetrieveConfiguration() -> Single<PaygateConfiguration?> {
        hasActiveSubscription()
            .flatMap { [weak self] activeSubscription -> Single<PaygateConfiguration?> in
                guard let this = self, !activeSubscription else {
                    let config = PaygateConfiguration(activeSubscription: true,
                                                      onboardingPaygate: false,
                                                      generateSpotPaygate: false,
                                                      navigateSpotPaygate: false,
                                                      learnPaygate: false,
                                                      seePaygate: false)
                    return .just(config)
                }
                
                return this.obtainConfiguration()
            }
            .do(onSuccess: { [weak self] configuration in
                guard let this = self, let config = configuration else {
                    return
                }
                
                this.store(configuration: config)
            })
    }
}

// MARK: Private
private extension PaygateConfigurationManagerCore {
    func hasActiveSubscription() -> Single<Bool> {
        SDKStorage.shared
            .purchaseManager
            .validateReceipt()
            .map { $0?.activeSubscription ?? false }
            .catchErrorJustReturn(false)
    }
    
    func obtainConfiguration() -> Single<PaygateConfiguration?> {
        SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: GetPaygateConfigurationRequest())
            .map { GetPaygateConfigurationResponseMapper.from(response: $0) }
    }
    
    func store(configuration: PaygateConfiguration) {
        guard let data = try? JSONEncoder().encode(configuration) else {
            return
        }
        
        UserDefaults.standard.setValue(data, forKey: Constants.configurationCacheKey)
    }
}
