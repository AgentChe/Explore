//
//  GetPlaceResponseMapper.swift
//  Explore
//
//  Created by Andrey Chernyshev on 06.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

final class GetPlaceResponseMapper {
    static func from(response: Any, with coordinate: Coordinate) -> Place? {
        array.randomElement()!
    }
}


let c1 = Coordinate(latitude: 55.753804, longitude: 37.621645)
let c2 = Coordinate(latitude: 55.863804, longitude: 37.731645)
let c3 = Coordinate(latitude: 55.713804, longitude: 37.601645)
let c4 = Coordinate(latitude: 55.453804, longitude: 37.921645)
let c5 = Coordinate(latitude: 55.393804, longitude: 37.71645)

let c = [c1, c2, c3, c4, c5]


let p1 = Place(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/58/Ritman_Library.png/250px-Ritman_Library.png",
               about: "Библиотеки впервые появились на древнем Востоке. Обычно первой библиотекой называют собрание глиняных табличек, приблизительно 2500 год до н. э., найденное в храме шумерского города Ниппур. В одной из гробниц близ египетских Фив был обнаружен ящик с папирусами времени II переходного периода (XVIII—XVII вв. до н. э.). В эпоху Нового царства Рамсесом II было собрано около 20 000 папирусов. Самая известная древневосточная библиотека — собрание клинописных табличек из дворца ассирийского царя VII века до н. э. Ашшурбанипала в Ниневии. Основная часть табличек содержит юридическую информацию. В древней Греции первая публичная библиотека была основана в Гераклее тираном Клеархом (IV век до н. э.).", coordinate: c.randomElement()!)

let p2 = Place(imageUrl: "https://fullpicture.ru/wp-content/uploads/2018/02/beautiful-places-in-germany1.jpg", about: "В её paспoряжении наxодится прекрасная земля с морями, пещерами, вyлканами и озерами, а её великолепная архитектура среди, которой шикарные соборы и дворцы завораживает и радует не только глаза, но и душу. Прежде чем отправится покорять и изучать новые страны и континенты, хорошенько оглядитесь вокруг и посмотрите на свою родину может быть стоит начать именно с неё…", coordinate: c.randomElement()!)

let p3 = Place(imageUrl: "https://s.zagranitsa.com/images/articles/1617/870x486/879f7813f11b5bc6c1425eb8a2b25b76.jpg?1443173205", about: "Пpирoдa, как искyсный мастер, создает свои собственные произведения, которые поражают своей красотой и великолепием. Миллионы лет этот «мастер» неустанно трудится над созданием своиx естественных шедевров.", coordinate: c.randomElement()!)

let p4 = Place(imageUrl: "https://www.russiadiscovery.ru/upload/files/files/Samie-krasivie-mesta-Rossii.jpg", about: "Пpирoдa России в этом плане одна из самыx yдивительных. Протянувшись от Балтики до Тихого океана, она вобрала в себя множество природных зон, которые и обусловили многообразие великолепных естественных пейзажей и мест для отдыха. Природа России настолько прекрасна и уникальна, что её смело можно назвать красивейшей страной планеты Земля.", coordinate: c.randomElement()!)

let p5 = Place(imageUrl: "https://www.russiadiscovery.ru/upload/files/files/Места-силы-России.jpg", about: "Скалы разрезали Приленское горное плато и напоминают античные колонны", coordinate: c.randomElement()!)

let array: [Place] = [
    p1, p2, p3, p4, p5
]



