//
//  AppDelegate.swift
//  Explore
//
//  Created by Andrey Chernyshev on 04.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(GlobalDefinitions.googleApiKey)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MapViewController.make()
        window?.makeKeyAndVisible()
        
        return true
    }
}
