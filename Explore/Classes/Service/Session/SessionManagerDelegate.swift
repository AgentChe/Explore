//
//  SessionManagerDelegate.swift
//  Explore
//
//  Created by Andrey Chernyshev on 09.10.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol SessionManagerDelegate: class {
    func sessionManagerDidStored(session: Session)
}

extension SessionManagerDelegate {
    func sessionManagerDidStored(session: Session) {}
}
