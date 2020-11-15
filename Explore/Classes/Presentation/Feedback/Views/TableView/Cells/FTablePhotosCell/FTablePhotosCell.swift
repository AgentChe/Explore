//
//  FTablePhotosCell.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class FTablePhotosCell: UITableViewCell {
    weak var vc: UIViewController!
    
    lazy var titleLabel = makeTitleLabel()
    lazy var scrollView = makeScrollView()
    
    private var element: FTableElement!
    
    private lazy var imagePicker = ImagePicker(presentationController: vc, delegate: self)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        makeConstraints()
        handleTapped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension FTablePhotosCell {
    func setup(element: FTableElement) {
        self.element = element
        
        setupImages(element: element)
    }
}

// MARK: ImagePickerDelegate
extension FTablePhotosCell: ImagePickerDelegate {
    func imagePickerDidSelect(image: UIImage?) {
        guard let img = image else {
            return
        }
        
        var newImages = element.newImages ?? []
        newImages.append(img)
        
        element.newImages = newImages
        
        setup(element: element)
    }
}

// MARK: Private
private extension FTablePhotosCell {
    func configure() {
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
    
    func setupImages(element: FTableElement) {
        let uploaded = element
            .uploadedThumbsImages?
            .compactMap { $0 }
            .map { FPhotoView.ElementType.uploadedImage($0) } ?? []
        
        let forDelete = element
            .uploadedThumbsImagesForDelete?
            .compactMap { $0 }
            .map { FPhotoView.ElementType.uploadedImageForDelete($0) } ?? []
        
        let newImages = element
            .newImages?
            .compactMap { $0 }
            .map { FPhotoView.ElementType.notUploadedImage(UUID().uuidString, $0) } ?? []
        
        var types = uploaded + forDelete + newImages
        
        if (uploaded.count + newImages.count) < 5 {
            types.append(.addMarker)
        }
        
        scrollView.setup(types: types)
    }
    
    func handleTapped() {
        scrollView.didTapped = { [weak self] view in
            guard let type = view.weak?.type else {
                return
            }
            
            switch type {
            case .uploadedImage(let image):
                self?.setUploadedForDelete(image: image)
            case .addMarker:
                self?.addImage()
            default:
                break
            }
        }
    }
    
    func setUploadedForDelete(image: JournalImage) {
        var uploadedThumbsImages = element.uploadedThumbsImages ?? []
        var uploadedThumbsImagesForDelete = element.uploadedThumbsImagesForDelete ?? []
        
        if !uploadedThumbsImagesForDelete.contains(where: { $0.id == image.id }) {
            uploadedThumbsImagesForDelete.append(image)
        }
        
        uploadedThumbsImages.removeAll(where: { $0.id == image.id })
        
        element.uploadedThumbsImages = uploadedThumbsImages
        element.uploadedThumbsImagesForDelete = uploadedThumbsImagesForDelete
        
        setup(element: element)
    }
    
    func addImage() {
        imagePicker.present(from: contentView)
    }
}

// MARK: Make constraints
private extension FTablePhotosCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.scale),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 72.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension FTablePhotosCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Font.Poppins.bold(size: 14.scale))
            .lineHeight(21.scale)
            .letterSpacing(0.5.scale)
        
        let view = UILabel()
        view.attributedText = "Feedback.PhotosCell.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeScrollView() -> FPhotosSlider {
        let view = FPhotosSlider()
        view.contentSize = .zero
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
