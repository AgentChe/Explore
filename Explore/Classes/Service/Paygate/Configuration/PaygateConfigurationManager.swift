//
//  PaygateConfigurationManager.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.10.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift

protocol PaygateConfigurationManager: class {
    // MARK: API
    func clearCache()
    func getConfiguration() -> PaygateConfiguration?
    func set(activeSubscription: Bool)
    
    // MARK: API(Rx)
    func rxRetrieveConfiguration() -> Single<PaygateConfiguration?>
}
