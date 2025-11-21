//
//  UpdateProfileRequest.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 02/09/2024.
//

import Foundation

struct UpdateProfileRequest: Codable {
    var name: String? = ""
    var phone: String? = ""
    var email: String? = ""
    var iban_image: Data?
}
