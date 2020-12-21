//
//  WallpaperNotAccessToPhotoLibraryAlert.swift
//  Explore
//
//  Created by Andrey Chernyshev on 16.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class WallpaperNotAccessToPhotoLibraryAlert {
    func makeAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Wallpaper.NoAccessToPhotoLibrary.Title".localized,
                                      message: "Wallpaper.NoAccessToPhotoLibrary.Message".localized,
                                      preferredStyle: .alert)
        
        let settings = UIAlertAction(title: "Settings".localized, style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) else {
                return
            }
            
            UIApplication.shared.open(settingsUrl)
        }
        
        let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel)
        
        alert.addAction(settings)
        alert.addAction(cancel)
        
        return alert
    }
}
