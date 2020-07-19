//
//  responseMessage.swift
//  OnMap
//
//  Created by Sarah Al-Matawah on 18/07/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import Foundation

struct ResponseMessage: Codable {
    let status: Int
    let message: String
}
