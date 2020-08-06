//
//  PlaceService.swift
//  Explore
//
//  Created by Andrey Chernyshev on 06.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift

final class PlaceManager {
    static let shared = PlaceManager()
    
    private init() {}
    
    private var delegates = [Weak<PlaceManagerDelegate>]()
}

// MARK: API

extension PlaceManager {
    func retrieve(with coordinate: Coordinate) -> Single<Place?> {
        guard checkNeedUpdate() else {
            return .deferred { .just(PlaceManager.shared.cached()) }
        }
        
        return update(coordinate: coordinate)
    }
    
    func get() -> Place? {
        cached()
    }
    
    func hasActualPlace() -> Bool {
        !checkNeedUpdate()
    }
}

// MARK: Observer

extension PlaceManager {
    func add(observer: PlaceManagerDelegate) {
        let weakly = observer as AnyObject
        delegates.append(Weak<PlaceManagerDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    func remove(observer: PlaceManagerDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === observer }) {
            delegates.remove(at: index)
        }
    }
}

// MARK: Private

private extension PlaceManager {
    func update(coordinate: Coordinate) -> Single<Place?> {
        RestAPITransport()
            .callServerApi(requestBody: GetPlaceRequest(coordinate: coordinate))
            .map { GetPlaceResponseMapper.from(response: $0, with: coordinate) }
            .do(onSuccess: { place in
                guard let place = place else {
                    return
                }
                
                PlaceManager.shared.removePlaceFromCache()
                PlaceManager.shared.cache(place: place)
                
                PlaceManager.shared.delegates.forEach { $0.weak?.placeManager(updated: place) }
            })
    }
    
    func cache(place: Place) {
        guard let data = try? Place.encode(object: place) else {
            return
        }
        
        UserDefaults.standard.set(data, forKey: Constants.storedPlaceKey)
        UserDefaults.standard.set(Date(), forKey: Constants.lastUpdatePlaceKey)
    }
    
    func cached() -> Place? {
        guard let data = UserDefaults.standard.data(forKey: Constants.storedPlaceKey) else {
            return nil
        }
        
        return try? JSONDecoder().decode(Place.self, from: data)
    }
    
    func removePlaceFromCache() {
        UserDefaults.standard.removeObject(forKey: Constants.storedPlaceKey)
        UserDefaults.standard.removeObject(forKey: Constants.lastUpdatePlaceKey)
    }
    
    func checkNeedUpdate() -> Bool {
        guard let lastUpdateDate = UserDefaults.standard.value(forKey: Constants.lastUpdatePlaceKey) as? Date else {
            return true
        }
        
        guard let passed = Calendar.current.dateComponents([.hour], from: lastUpdateDate, to: Date()).hour else {
            return true
        }
        
        return passed >= 1
    }
}

// MARK: Constants

private extension PlaceManager {
    struct Constants {
        static let storedPlaceKey = "place_manager_stored_place_key"
        static let lastUpdatePlaceKey = "place_manager_last_update_place_key"
    }
}
