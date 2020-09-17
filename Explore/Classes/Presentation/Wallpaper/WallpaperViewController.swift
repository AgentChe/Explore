//
//  WallpaperViewController.swift
//  Explore
//
//  Created by Andrey Chernyshev on 16.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class WallpaperViewController: UIViewController {
    var wallpaperView = WallpaperView()
    
    private let wallpaper: Wallpaper
    
    private let disposeBag = DisposeBag()
    
    private let settingsAlert = WallpaperNotAccessToPhotoLibraryAlert().makeAlert()
    private let photoLibraryWrapper = PhotoLibraryWrapper()
    
    private var savedImageNotificationTimer: Timer?
    
    private init(wallpaper: Wallpaper) {
        self.wallpaper = wallpaper
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = wallpaperView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        hideAll()
        showActions()
        
        wallpaperView.actionsView
            .closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        wallpaperView.actionsView
            .saveButton.rx.tap
            .withLatestFrom(Observable.just(wallpaper))
            .flatMapLatest { [weak self] wallpaper in
                self?.photoLibraryWrapper.write(imageUrl: wallpaper.imageUrl) ?? .never()
            }
            .subscribe(onNext: { [weak self] result in
                self?.handle(result: result)
            })
            .disposed(by: disposeBag)
         
        wallpaperView.actionsView
            .previewButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showPreview()
            })
            .disposed(by: disposeBag)
        
        let previewTapGesture = UITapGestureRecognizer()
        wallpaperView.previewView.isUserInteractionEnabled = true
        wallpaperView.previewView.addGestureRecognizer(previewTapGesture)
        previewTapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.showActions()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make

extension WallpaperViewController {
    static func make(wallpaper: Wallpaper) -> WallpaperViewController {
        let vc = WallpaperViewController(wallpaper: wallpaper)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        return vc
    }
}

// MARK: Private

private extension WallpaperViewController {
    func setup() {
        if let url = URL(string: wallpaper.imageUrl) {
            wallpaperView.wallpaperImageView.kf.setImage(with: url)
        }
    }
    
    func hideAll() {
        [
            wallpaperView.actionsView,
            wallpaperView.previewView,
            wallpaperView.notifyAboutSavedLabel
        ]
            .forEach {
                $0.isHidden = true
                $0.alpha = 0
            }
    }
    
    func handle(result: PhotoLibraryWrapper.Result) {
        switch result {
        case .deniedPermission:
            present(settingsAlert, animated: true)
        case .failure:
            Toast.notify(with: "Wallpaper.SavedToCameraRoll.Failure".localized, style: .danger)
        case .savedToPhotosAlbum:
            notifyAboutSavedImage()
        }
    }
    
    func showActions() {
        hideAll()
        
        wallpaperView.actionsView.isHidden = false
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.wallpaperView.actionsView.alpha = 1
        })
    }
    
    func showPreview() {
        hideAll()
        
        wallpaperView.previewView.update()
        
        wallpaperView.previewView.isHidden = false
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.wallpaperView.previewView.alpha = 1
        })
    }
    
    func notifyAboutSavedImage() {
        wallpaperView.notifyAboutSavedLabel.layer.removeAllAnimations()
        
        wallpaperView.notifyAboutSavedLabel.isHidden = false
        wallpaperView.notifyAboutSavedLabel.alpha = 1
        
        UIView.animate(withDuration: 2, animations: { [weak self] in
            self?.wallpaperView.notifyAboutSavedLabel.alpha = 0
        })
    }
}
