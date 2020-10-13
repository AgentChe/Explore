//
//  DirectCollectionTermsOfServiceCell.swift
//  Explore
//
//  Created by Andrey Chernyshev on 24.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class DirectCollectionTermsOfServiceCell: UICollectionViewCell {
    lazy var label = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.clear
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private

private extension DirectCollectionTermsOfServiceCell {
    @objc
    func tapped(gesture: UITapGestureRecognizer) {
        let termsOfServiceRange = ((label.text ?? "") as NSString).range(of: "TermsOfService".localized)
        let privacyPolicy = ((label.text ?? "") as NSString).range(of: "PrivacyPolicy".localized)
        
        var url: URL?
        
        if gesture.didTapAttributedTextInLabel(label: label, inRange: termsOfServiceRange) {
            url = URL(string: GlobalDefinitions.termsOrServiceUrl)
        } else if gesture.didTapAttributedTextInLabel(label: label, inRange: privacyPolicy) {
            url = URL(string: GlobalDefinitions.privacyPolicyUrl)
        }
        
        if let _url = url {
            UIApplication.shared.open(_url, options: [:])
        }
    }
}

// MARK: Make constraints

private extension DirectCollectionTermsOfServiceCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.scale),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.scale),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension DirectCollectionTermsOfServiceCell {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Font.SFProText.regular(size: 15.scale))
            .lineHeight(17.scale)
            .textAlignment(.center)
        
        let underlineAttrs = attrs.underlineStyle(.single)
        
        let terms = "TermsOfService".localized.attributed(with: underlineAttrs)
        let policy = "PrivacyPolicy".localized.attributed(with: underlineAttrs)
        let and = "Direct.And".localized.attributed(with: attrs)
        
        let text = NSMutableAttributedString()
        text.append(terms)
        text.append(and)
        text.append(policy)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = text
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped(gesture:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        
        return view
    }
}
