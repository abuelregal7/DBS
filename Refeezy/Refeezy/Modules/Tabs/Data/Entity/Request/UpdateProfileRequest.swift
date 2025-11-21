//
//  UpdateProfileRequest.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 08/04/2025.
//

import Foundation

struct UpdateProfileRequest: Codable {
    var name: String? = ""
    var phone: String? = ""
    var email: String? = ""
    var image: Data?
}
