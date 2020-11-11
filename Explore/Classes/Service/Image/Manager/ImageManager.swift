//
//  ImageManager.swift
//  Explore
//
//  Created by Andrey Chernyshev on 10.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

protocol ImageManager: class {
    func upload(image: UIImage) -> Single<Picture?>
}
