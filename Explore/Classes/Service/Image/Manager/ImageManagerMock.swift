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
    func upload(image: UIImage) -> Single<Image?> {
        Single<Image?>
            .create { event in
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2) {
                    DispatchQueue.main.async {
                        let result = Image(id: Int.random(in: 0...Int.max),
                                           url: "https://onlinepngtools.com/images/examples-onlinepngtools/clouds-transparent.png")
                        
                        event(.success(result))
                    }
                }
                
                return Disposables.create()
            }
    }
}
