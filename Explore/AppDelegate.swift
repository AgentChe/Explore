//
//  AppDelegate.swift
//  Explore
//
//  Created by Andrey Chernyshev on 04.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import GoogleMaps
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(GlobalDefinitions.googleApiKey)
        PurchaseManager.register()
        FacebookAnalytics.shared.configure()
        IDFAService.shared.initialize()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        AppRegisterManager.shared.configure()
        
        AmplitudeManager.shared.configure()
        
        PaygateConfigurationManagerCore().clearCache()
        
        UniversalLinksService.shared.register(didFinishLaunchingWithOptions: launchOptions)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = SplashViewController.make()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, options: options)
        UniversalLinksService.shared.register(with: url, options: options)
        
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        UniversalLinksService.shared.register(with: userActivity)
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppStateManager.shared.applicationDidBecome()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        AppStateManager.shared.applicationWillResign()
    }
}
