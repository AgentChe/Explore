//
//  FPhotoView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import Kingfisher

final class FPhotoView: UIView {
    enum ElementType {
        case uploadedImage(JournalImage)
        case uploadedImageForDelete(JournalImage)
        case notUploadedImage(String, UIImage)
        case addMarker
    }
    
    lazy var imageView = makeFillImageView()
    lazy var crossImageView = makeFitImageView(image: "Feedback.Close")
    lazy var basketImageView = makeFitImageView(image: "Feedback.Delete")
    lazy var addImageView = makeFitImageView(image: "Feedback.Add")
    lazy var shroudView = makeShroudView()
    
    private(set) var type: ElementType = .addMarker
    
    convenience init(type: ElementType) {
        self.init(frame: .zero)
        
        self.type = type
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
    }
}

// MARK: Private
private extension FPhotoView {
    func setup() {
        switch type {
        case .uploadedImage(let image):
            setup(uploadedImage: image)
        case .uploadedImageForDelete(let image):
            setup(uploadedImageForDelete: image)
        case .notUploadedImage(let uuid, let image):
            setup(notUploadedImage: image, uuid: uuid)
        case .addMarker:
            setupAddMarker()
        }
    }
    
    func setup(uploadedImage: JournalImage) {
        guard let url = URL(string: uploadedImage.url) else {
            return
        }
        
        imageView.isHidden = false
        imageView.kf.setImage(with: url)
        
        basketImageView.isHidden = false
    }
    
    func setup(uploadedImageForDelete: JournalImage) {
        guard let url = URL(string: uploadedImageForDelete.url) else {
            return
        }
        
        imageView.isHidden = false
        imageView.kf.setImage(with: url)
        
        crossImageView.isHidden = false
        
        shroudView.isHidden = false
    }
    
    func setup(notUploadedImage: UIImage, uuid: String) {
        imageView.isHidden = false
        imageView.image = notUploadedImage
        
        shroudView.isHidden = false
    }
    
    func setupAddMarker() {
        addImageView.isHidden = false
    }
}

// MARK: Make constraints
private extension FPhotoView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            shroudView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shroudView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shroudView.topAnchor.constraint(equalTo: topAnchor),
            shroudView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            basketImageView.widthAnchor.constraint(equalToConstant: 24.scale),
            basketImageView.heightAnchor.constraint(equalToConstant: 24.scale),
            basketImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            basketImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            crossImageView.widthAnchor.constraint(equalToConstant: 24.scale),
            crossImageView.heightAnchor.constraint(equalToConstant: 24.scale),
            crossImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            crossImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addImageView.widthAnchor.constraint(equalToConstant: 24.scale),
            addImageView.heightAnchor.constraint(equalToConstant: 24.scale),
            addImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            addImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension FPhotoView {
    func makeFillImageView() -> UIImageView {
        let view = UIImageView()
        view.isHidden = true
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFitImageView(image: String) -> UIImageView {
        let view = UIImageView()
        view.isHidden = true
        view.clipsToBounds = true
        view.image = UIImage(named: image)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeShroudView() -> UIView {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = UIColor(red: 238 / 255, green: 223 / 255, blue: 242 / 255, alpha: 0.75)
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
