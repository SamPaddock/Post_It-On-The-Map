//
//  authenticationModel.swift
//  OnMap
//
//  Created by Sarah Al-Matawah on 17/07/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import Foundation

struct Udacity: Codable {
    let udacity: Auth
}

struct Auth: Codable {
    let username: String
    let passowrd: String
}
