//
//  AppDelegate.swift
//  Explore
//
//  Created by Andrey Chernyshev on 04.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import GoogleMaps
import RxCocoa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    let sdkProvider = SDKProvider()
    
    private let generateStepInSplash = PublishRelay<Void>()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = SplashViewController.make(generateStep: generateStepInSplash.asSignal())
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        addDelegates()
        
        startSDKProvider(on: vc.view)
        
        sdkProvider.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        GMSServices.provideAPIKey(GlobalDefinitions.googleApiKey)
        PaygateConfigurationManagerCore().clearCache()
        AppsFlyerAnalytics.shared.applicationDidFinishLaunchingWithOptions()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        sdkProvider.application(app, open: url, options: options)
        
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        sdkProvider.application(application, continue: userActivity, restorationHandler: restorationHandler)
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppStateManager.shared.applicationDidBecome()
        AppsFlyerAnalytics.shared.applicationDidBecomeActive()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        AppStateManager.shared.applicationWillResign()
    }
}

// MARK: SDKPurchaseMediatorDelegate
extension AppDelegate: SDKPurchaseMediatorDelegate {
    func purchaseMediatorDidValidateReceipt(response: ReceiptValidateResponse?) {
        guard let response = response else {
            return
        }
        
        PaygateConfigurationManagerCore().set(activeSubscription: response.activeSubscription)
        
        let session = Session(userToken: response.userToken,
                              activeSubscription: response.activeSubscription,
                              userId: response.userId)
        SessionManager.shared.store(session: session)
    }
}

// MARK: Private
private extension AppDelegate {
    func startSDKProvider(on view: UIView) {
        let sdkSettings = SDKSettings(backendBaseUrl: GlobalDefinitions.sdkDomainUrl,
                                      backendApiKey: GlobalDefinitions.sdkApiKey,
                                      amplitudeApiKey: GlobalDefinitions.amplitudeAPIKey,
                                      facebookActive: true,
                                      branchActive: false,
                                      firebaseActive: false,
                                      applicationTag: GlobalDefinitions.applicationTag,
                                      userToken: SessionManager.shared.getSession()?.userToken,
                                      userId: SessionManager.shared.getSession()?.userId,
                                      view: view,
                                      shouldAddStorePayment: false,
                                      isTest: false)
        
        sdkProvider.initialize(settings: sdkSettings) { [weak self] in
            self?.generateStepInSplash.accept(Void())
        }
    }
    
    func addDelegates() {
        SDKStorage.shared.purchaseMediator.add(delegate: self)
    }
}
