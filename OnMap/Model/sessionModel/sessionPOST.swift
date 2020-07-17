//
//  sessionPOST.swift
//  OnMap
//
//  Created by Sarah Al-Matawah on 14/07/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import Foundation

struct SessionPOST: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: Int
    
}

struct Session: Codable {
    let id: String
    let expiration: String
}
