//
//  PhotoLibraryWrapper.swift
//  Explore
//
//  Created by Andrey Chernyshev on 16.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Photos
import RxSwift
import RxCocoa
import Kingfisher

final class PhotoLibraryWrapper: NSObject {
    enum Result {
        case deniedPermission
        case savedToPhotosAlbum
        case failure
    }
    
    private let trigger = PublishRelay<Result>()
}

// MARK: API

extension PhotoLibraryWrapper {
    func write(imageUrl: String) -> Signal<Result> {
        defer {
            permissionIsGranted(imageUrl: imageUrl)
        }
        
        return .deferred { [weak self] in
            guard let this = self else {
                return .never()
            }
            
            return this.trigger.asSignal()
        }
    }
}

// MARK: Private

private extension PhotoLibraryWrapper {
    func permissionIsGranted(imageUrl: String) {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .denied:
                    self?.trigger.accept(.deniedPermission)
                default:
                    self?.retrieveImage(imageUrl: imageUrl)
                }
            }
        }
    }
    
    func retrieveImage(imageUrl: String) {
        DispatchQueue.global().async {
            ImageCache.default.retrieveImage(forKey: imageUrl) { [weak self] result in
                DispatchQueue.main.async {
                    guard case let .success(cache) = result, let cgImage = cache.image?.cgImage else {
                        self?.trigger.accept(.failure)
                        
                        return
                    }
                
                    let image = UIImage(cgImage: cgImage)
                    
                    self?.saveToAlbum(image: image)
                }
            }
        }
    }
    
    func saveToAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        DispatchQueue.main.async { [weak self] in
            let result = error != nil ? Result.failure : Result.savedToPhotosAlbum
            
            self?.trigger.accept(result)
        }
    }
}
