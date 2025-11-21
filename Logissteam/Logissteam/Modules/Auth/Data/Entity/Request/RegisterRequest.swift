//
//  RegisterRequest.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 01/09/2024.
//

import Foundation

struct RegisterRequest: Codable {
    var name: String? = ""
    var phone: String? = ""
    var email: String? = ""
    var iban_image: Data?
}
