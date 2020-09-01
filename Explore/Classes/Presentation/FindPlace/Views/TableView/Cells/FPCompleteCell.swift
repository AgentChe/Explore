//
//  FPCompleteCell.swift
//  Explore
//
//  Created by Andrey Chernyshev on 31.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class FPCompleteCell: UITableViewCell {
    weak var delegate: FindPlaceTableDelegate?
    
    lazy var startButton = makeStartButton()
    lazy var resetButton = makeResetButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private

private extension FPCompleteCell {
    @objc
    func startButtonTapped() {
        delegate?.findPlaceTableDidStart()
    }
    
    @objc
    func resetButtonTapped() {
        delegate?.findPlaceTableDidReset()
    }
}

// MARK: Make constraints

private extension FPCompleteCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            startButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            startButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32.scale),
            startButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 48.scale)
        ])
        
        NSLayoutConstraint.activate([
            resetButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            resetButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32.scale),
            resetButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 16.scale),
            resetButton.heightAnchor.constraint(equalToConstant: 48.scale),
            resetButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension FPCompleteCell {
    func makeStartButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        view.layer.cornerRadius = 16.scale
        view.setTitleColor(UIColor.black, for: .normal)
        view.setTitle("FindPlace.FPCompleteCell.Start".localized, for: .normal)
        view.titleLabel?.font = Font.SFCompactText.regular(size: 18.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
    
    func makeResetButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        view.layer.cornerRadius = 16.scale
        view.setTitleColor(UIColor.black, for: .normal)
        view.setTitle("FindPlace.FPCompleteCell.Reset".localized, for: .normal)
        view.titleLabel?.font = Font.SFCompactText.regular(size: 18.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
}
