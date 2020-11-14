//
//  FeedbackTableView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 13.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class FeedbackTableView: UITableView {
    private var element: FTableElement!
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension FeedbackTableView {
    func setup(element: FTableElement) {
        self.element = element
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension FeedbackTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let element = self.element else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case 0:
            let cell = dequeueReusableCell(withIdentifier: String(describing: FTableTitleCell.self)) as! FTableTitleCell
            cell.setup(element: element)
            return cell
        case 1:
            let cell = dequeueReusableCell(withIdentifier: String(describing: FTableRatingCell.self)) as! FTableRatingCell
            cell.setup(element: element)
            return cell
        case 2:
            let cell = dequeueReusableCell(withIdentifier: String(describing: FTableDescriptionCell.self)) as! FTableDescriptionCell
            cell.setup(element: element)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: UITableViewDelegate
extension FeedbackTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        18.scale
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 71.scale
        case 1:
            return 65.scale
        case 2:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
}

// MARK: Private
private extension FeedbackTableView {
    func configure() {
        register(FTableTitleCell.self, forCellReuseIdentifier: String(describing: FTableTitleCell.self))
        register(FTableRatingCell.self, forCellReuseIdentifier: String(describing: FTableRatingCell.self))
        register(FTableDescriptionCell.self, forCellReuseIdentifier: String(describing: FTableDescriptionCell.self))
        
        dataSource = self
        delegate = self
    }
}
