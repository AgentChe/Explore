//
//  FindPlaceTableView.swift
//  Explore
//
//  Created by Andrey Chernyshev on 31.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class FindPlaceTableView: UITableView {
    weak var fpTableDelegate: FindPlaceTableDelegate?
    
    private var sections = [FindPlaceTableSection]()
    
    private var queue = DispatchQueue(label: "find_place_table_queue")
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API

extension FindPlaceTableView {
    func add(section: FindPlaceTableSection) {
        queue.sync { [weak self] in
            self?.sections.insert(section, at: 0)
            
            self?.insertSections(IndexSet(integer: 0), with: .bottom)
        }
    }
    
    func removeAll() {
        queue.sync { [weak self] in
            self?.sections.removeAll()
            
            self?.reloadData()
        }
    }
    
    func replace(section: FindPlaceTableSection) {
        queue.sync { [weak self] in
            var sectionsIndexes = [Int]()
            
            self?.sections.enumerated().forEach {
                guard $1.identifier == section.identifier else {
                    return
                }
                
                self?.sections[$0] = section
                
                sectionsIndexes.append($0)
            }
            
            self?.reloadSections(IndexSet(sectionsIndexes), with: .middle)
        }
    }
    
    func replaceOrAdd(section: FindPlaceTableSection) {
        DispatchQueue.main.async { [weak self] in
            guard let this = self else {
                return
            }
            
            if this.sections.contains(where: { $0.identifier == section.identifier }) {
                this.replace(section: section)
            } else {
                this.add(section: section)
            }
        }
    }
}
 
// MARK: UITableViewDataSource
 
extension FindPlaceTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let item = section.items[indexPath.row]
        
        let returnCell: UITableViewCell
       
        switch item {
        case .requireGeoPermission:
            let cell = dequeueReusableCell(withIdentifier: String(describing: FPRequireGeoPermissionCell.self)) as! FPRequireGeoPermissionCell
            cell.delegate = fpTableDelegate
            returnCell = cell
        case .notification(let message):
            let cell = dequeueReusableCell(withIdentifier: String(describing: FPNotificationCell.self)) as! FPNotificationCell
            cell.setup(message: message)
            returnCell = cell
        case .searchedCoordinate(let coordinate):
            let cell = dequeueReusableCell(withIdentifier: String(describing: FPSearchedCoordinateCell.self)) as! FPSearchedCoordinateCell
            cell.setup(coordinate: coordinate)
            returnCell = cell
        case .whatLikeGet(let tag):
            let cell = dequeueReusableCell(withIdentifier: String(describing: FPWhatLikeGetCell.self)) as! FPWhatLikeGetCell
            cell.delegate = fpTableDelegate
            cell.setup(selectedTag: tag)
            returnCell = cell
        case .complete:
            let cell = dequeueReusableCell(withIdentifier: String(describing: FPCompleteCell.self)) as! FPCompleteCell
            cell.delegate = fpTableDelegate
            returnCell = cell
        case .deniedGeoPermission:
            let cell = dequeueReusableCell(withIdentifier: String(describing: FPDeniedGeoPermissionCell.self)) as! FPDeniedGeoPermissionCell
            cell.delegate = fpTableDelegate
            returnCell = cell
        case .whatItis:
            let cell = dequeueReusableCell(withIdentifier: String(describing: FPWhatItIsCell.self)) as! FPWhatItIsCell
            returnCell = cell
        case .radius(let bundle):
            let cell = dequeueReusableCell(withIdentifier: String(describing: FPRadiusCell.self)) as! FPRadiusCell
            cell.delegate = fpTableDelegate
            cell.setup(bundle: bundle)
            returnCell = cell
        }
        
        returnCell.backgroundColor = UIColor.clear
        returnCell.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        return returnCell
    }
}

// MARK: UITableViewDelegate

extension FindPlaceTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        20.scale
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
}

// MARK: Private

private extension FindPlaceTableView {
    func configure() {
        register(FPRequireGeoPermissionCell.self, forCellReuseIdentifier: String(describing: FPRequireGeoPermissionCell.self))
        register(FPNotificationCell.self, forCellReuseIdentifier: String(describing: FPNotificationCell.self))
        register(FPSearchedCoordinateCell.self, forCellReuseIdentifier: String(describing: FPSearchedCoordinateCell.self))
        register(FPWhatLikeGetCell.self, forCellReuseIdentifier: String(describing: FPWhatLikeGetCell.self))
        register(FPCompleteCell.self, forCellReuseIdentifier: String(describing: FPCompleteCell.self))
        register(FPDeniedGeoPermissionCell.self, forCellReuseIdentifier: String(describing: FPDeniedGeoPermissionCell.self))
        register(FPWhatItIsCell.self, forCellReuseIdentifier: String(describing: FPWhatItIsCell.self))
        register(FPRadiusCell.self, forCellReuseIdentifier: String(describing: FPRadiusCell.self))
        
        dataSource = self
        delegate = self
    }
}
