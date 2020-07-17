//
//  StudentInformation.swift
//  OnMap
//
//  Created by Sarah Al-Matawah on 13/07/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import Foundation

struct StudentInformation: Codable {
    var createdAt: String?
    var firstName: String?
    var lastName: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectId: String?
    var uniqueKey: String?
    var updatedAt: String?
}

extension StudentInformation {
    init(mapString: String, mediaURL: String){
        self.mapString = mapString
        self.mediaURL = mediaURL
    }
}
