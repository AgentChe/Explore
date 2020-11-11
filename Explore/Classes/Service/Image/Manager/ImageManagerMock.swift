//
//  ImageManagerMock.swift
//  Explore
//
//  Created by Andrey Chernyshev on 10.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class ImageManagerMock: ImageManager {}

// MARK: API(Rx)
extension ImageManagerMock {
    func upload(image: UIImage) -> Single<Picture?> {
        Single<Picture?>
            .create { event in
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2) {
                    DispatchQueue.main.async {
                        let thumb = Image(id: Int.random(in: 0...Int.max),
                                          url: "https://onlinepngtools.com/images/examples-onlinepngtools/clouds-transparent.png")
                        
                        let origin = Image(id: Int.random(in: 0...Int.max),
                                           url: "https://onlinepngtools.com/images/examples-onlinepngtools/clouds-transparent.png")
                        
                        let picture = Picture(thumb: thumb, origin: origin)
                        
                        event(.success(picture))
                    }
                }
                
                return Disposables.create()
            }
    }
}
