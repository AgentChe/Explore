//
//  ImageManagerCore.swift
//  Explore
//
//  Created by Andrey Chernyshev on 10.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire

final class ImageManagerCore: ImageManager {}

// MARK: API(Rx)
extension ImageManagerCore {
    func upload(image: UIImage) -> Single<Picture?> {
        guard let userToken = SessionManager.shared.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        return upload(url: GlobalDefinitions.domain + "/api/images/upload",
               image: image,
               mimeType: "image/jpg",
               name: "image",
               fileName: String(format: "%@%@.jpeg", UUID().uuidString, String(Date().timeIntervalSinceNow)),
               parameters: ["_api_key": GlobalDefinitions.apiKey,
                            "_user_token": userToken])
            .map { UploadImageResponseMapper.map(from: $0) }
    }
}

// MARK: Private
private extension ImageManagerCore {
    func upload(url: String,
                image: UIImage,
                mimeType: String,
                name: String,
                fileName: String,
                parameters: [String: String] = [:],
                progress: ((Double) -> Void)? = nil) -> Single<Any> {
        Single<Any>.create { event in
            guard let imageData = image.jpegData(compressionQuality: 0.5) else {
                event(.failure(ApiError.serverNotAvailable))
                return Disposables.create()
            }
            
            let request = AF
                .upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(imageData,
                                             withName: name,
                                             fileName: fileName,
                                             mimeType: mimeType)
                
                    for (key, value) in parameters {
                        if let data = value.data(using: .utf8) {
                            multipartFormData.append(data, withName: key)
                        }
                    }
                }, to: url)
                .uploadProgress(queue: .main) { value in
                    progress?(value.fractionCompleted)
                }
                .responseJSON { response in
                    switch response.result {
                    case .success(let json):
                        event(.success(json))
                    case .failure(let error):
                        event(.failure(error))
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
