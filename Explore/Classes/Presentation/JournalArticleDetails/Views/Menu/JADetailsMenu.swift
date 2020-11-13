//
//  JADetailsMenu.swift
//  Explore
//
//  Created by Andrey Chernyshev on 12.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class JADetailsMenu: UIView {
    lazy var editItem = makeItem(image: "JADetails.Edit", title: "JADetails.Edit")
    lazy var shareItem = makeItem(image: "JADetails.Share", title: "JADetails.Share")
    lazy var deleteItem = makeItem(image: "JADetails.Delete", title: "JADetails.Delete")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension JADetailsMenu {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            editItem.leadingAnchor.constraint(equalTo: leadingAnchor),
            editItem.trailingAnchor.constraint(equalTo: trailingAnchor),
            editItem.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            shareItem.leadingAnchor.constraint(equalTo: leadingAnchor),
            shareItem.trailingAnchor.constraint(equalTo: trailingAnchor),
            shareItem.topAnchor.constraint(equalTo: editItem.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            deleteItem.leadingAnchor.constraint(equalTo: leadingAnchor),
            deleteItem.trailingAnchor.constraint(equalTo: trailingAnchor),
            deleteItem.topAnchor.constraint(equalTo: shareItem.bottomAnchor),
            deleteItem.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension JADetailsMenu {
    func makeItem(image: String, title: String) -> JADetailsMenuItem {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Font.Poppins.regular(size: 13.scale))
            .lineHeight(18.scale)
        
        let view = JADetailsMenuItem()
        view.backgroundColor = UIColor.clear
        view.imageView.image = UIImage(named: image)
        view.label.attributedText = title.localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

