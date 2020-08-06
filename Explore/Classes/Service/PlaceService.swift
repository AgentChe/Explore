//
//  PlaceService.swift
//  Explore
//
//  Created by Andrey Chernyshev on 06.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift

final class PlaceService {
    static func getPlace(for coordinate: Coordinate) -> Single<Place?> {
        RestAPITransport()
            .callServerApi(requestBody: GetPlaceRequest(coordinate: coordinate))
            .map { Place.parseFromDictionary(any: $0) }
        .catchErrorJustReturn(Place(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/58/Ritman_Library.png/250px-Ritman_Library.png",
                                    about: "Библиотеки впервые появились на древнем Востоке. Обычно первой библиотекой называют собрание глиняных табличек, приблизительно 2500 год до н. э., найденное в храме шумерского города Ниппур. В одной из гробниц близ египетских Фив был обнаружен ящик с папирусами времени II переходного периода (XVIII—XVII вв. до н. э.). В эпоху Нового царства Рамсесом II было собрано около 20 000 папирусов. Самая известная древневосточная библиотека — собрание клинописных табличек из дворца ассирийского царя VII века до н. э. Ашшурбанипала в Ниневии. Основная часть табличек содержит юридическую информацию. В древней Греции первая публичная библиотека была основана в Гераклее тираном Клеархом (IV век до н. э.)."))
    }
}
