//
//  LearnContentCollectionView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 22.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class LearnContentTableView: UITableView {
    weak var actionsDelegate: LearnContentTableViewDelegate?
    
    private var models = [LearnContentTableModel]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API

extension LearnContentTableView {
    func setup(models: [LearnContentTableModel]) {
        self.models = models
        
        reloadData()
    }
}

// MARK: Private

extension LearnContentTableView {
    func setup() {
        register(LearnContentTableTitleCell.self, forCellReuseIdentifier: String(describing: LearnContentTableTitleCell.self))
        register(LearnContentTableImageCell.self, forCellReuseIdentifier: String(describing: LearnContentTableImageCell.self))
        register(LearnContentTableTextCell.self, forCellReuseIdentifier: String(describing: LearnContentTableTextCell.self))
        
        dataSource = self
        delegate = self
    }
}

// MARK: UITableViewDataSource

extension LearnContentTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch models[indexPath.section] {
        case .title(let articleName):
            let cell = dequeueReusableCell(withIdentifier: String(describing: LearnContentTableTitleCell.self), for: indexPath) as! LearnContentTableTitleCell
            cell.delegate = actionsDelegate
            cell.setup(articleName: articleName)
            return cell
        case .image(let imageUrl):
            let cell = dequeueReusableCell(withIdentifier: String(describing: LearnContentTableImageCell.self), for: indexPath) as! LearnContentTableImageCell
            cell.setup(imageUrl: imageUrl)
            return cell
        case .text(let text):
            let cell = dequeueReusableCell(withIdentifier: String(describing: LearnContentTableTextCell.self), for: indexPath) as! LearnContentTableTextCell
            cell.setup(text: text)
            return cell
        }
    }
}

// MARK: UITableViewDelegate

extension LearnContentTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch models[indexPath.section] {
        case .title:
            return UITableView.automaticDimension
        case .image:
            return 316.scale
        case .text:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        32.scale
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view 
    }
}
