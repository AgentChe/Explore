//
//  WOViewController.swift
//  Explore
//
//  Created by Andrey Chernyshev on 22.12.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class WOViewController: UIViewController {
    lazy var mainView = WOView()
    
    private struct Constants {
        static let wasOpenedKey = "wo_view_controller_was_opened"
    }
    
    private let complete: ((WOViewController) -> Void)
    
    private let disposeBag = DisposeBag()
    
    private init(complete: @escaping ((WOViewController) -> Void)) {
        self.complete = complete
        
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        markAsViewed()
        setupSlider()
        
        mainView
            .button.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let this = self else {
                    return
                }
                
                this.complete(this)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension WOViewController {
    static func make(complete: @escaping ((WOViewController) -> Void)) -> WOViewController {
        let vc = WOViewController(complete: complete)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: API
extension WOViewController {
    static var wasViewed: Bool {
        UserDefaults.standard.bool(forKey: Constants.wasOpenedKey)
    }
}

// MARK: Private
private extension WOViewController {
    func markAsViewed() {
        UserDefaults.standard.set(true, forKey: Constants.wasOpenedKey)
    }
    
    func setupSlider() {
        let images = [
            UIImage(named: "WallpapersOnboarding.Image1"),
            UIImage(named: "WallpapersOnboarding.Image2"),
            UIImage(named: "WallpapersOnboarding.Image3")
        ].compactMap { $0 }
        
        let titles = [
            "WallpapersOnboarding.Title1".localized,
            "WallpapersOnboarding.Title2".localized,
            "WallpapersOnboarding.Title3".localized
        ]
        
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Font.Poppins.bold(size: 32.scale))
            .lineHeight(48.scale)
        
        mainView.slider.setup(images: images)
        
        mainView.slider.didSelected = { [weak self] index in
            guard titles.indices.contains(index) else {
                return
            }
            
            self?.mainView.indicatorsView.index = index
            self?.mainView.label.attributedText = titles[index].attributed(with: attrs)
        }
        
        mainView.indicatorsView.count = images.count
        mainView.label.attributedText = titles[0].attributed(with: attrs)
    }
}
