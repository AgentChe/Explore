//
//  WallpapersViewModel.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class WallpapersViewModel {
    lazy var elements = createElements()
    lazy var needPayment = createNeedPaymentSignal()
    
    private let wallpapersManager = WallpapersManagerCore()
    
    private let needPaymentTrigger = PublishRelay<Void>()
}

// MARK: Private

private extension WallpapersViewModel {
    func createElements() -> Driver<[WallpaperCollectionElement]> {
        let cached = Driver<Wallpapers?>
            .deferred { [wallpapersManager] in
                .just( wallpapersManager.getWallpapers())
            }
        
        let updated = wallpapersManager
            .rxGetWallpapers(forceUpdate: true)
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
            .asDriver(onErrorJustReturn: nil)
        
        return Driver<Wallpapers?>
            .merge(cached, updated)
            .map { wallpapers -> [WallpaperCollectionElement] in
                guard let list = wallpapers?.list else {
                    return []
                }
                
                return list
                    .sorted(by: { $0.sort < $1.sort })
                    .map { WallpaperCollectionElement(wallpaper: $0) }
            }
    }
    
    func createNeedPaymentSignal() -> Signal<Void> {
        needPaymentTrigger.asSignal()
    }
}
