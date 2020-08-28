//
//  MapAppsActionSheet.swift
//  Explore
//
//  Created by Andrey Chernyshev on 28.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class MapAppsActionSheet {
    func alert(coordinate: Coordinate, complete: @escaping (() -> Bool)) -> UIAlertController {
        let alert = UIAlertController(title: nil,
                                      message: "Map.MapAppsActionSheet.Message".localized,
                                      preferredStyle: .actionSheet)
        
        if OpenMaps.canOpenAppleMaps {
            let action = UIAlertAction(title: "Map.MapAppsActionSheet.AppleMap".localized, style: .default) { _ in
                if complete() {
                    OpenMaps.openAppleMaps(with: coordinate)
                }
            }
            
            alert.addAction(action)
        }
        
        if OpenMaps.canOpenGoogleMaps {
            let action = UIAlertAction(title: "Map.MapAppsActionSheet.GoogleMap".localized, style: .default) { _ in
                if complete() {
                    OpenMaps.openGoogleMaps(with: coordinate)
                }
            }
            
            alert.addAction(action)
        }
        
        if OpenMaps.canOpenDGIS {
            let action = UIAlertAction(title: "Map.MapAppsActionSheet.DGis".localized, style: .default) { _ in
                if complete() {
                    OpenMaps.openDGis(with: coordinate)
                }
            }
            
            alert.addAction(action)
        }
        
        if OpenMaps.canOpenYandexMaps {
            let action = UIAlertAction(title: "Map.MapAppsActionSheet.YandexMap".localized, style: .default) { _ in
                if complete() {
                    OpenMaps.openYandexMaps(with: coordinate)
                }
            }
            
            alert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
        alert.addAction(cancelAction)
        
        return alert
    }
}
