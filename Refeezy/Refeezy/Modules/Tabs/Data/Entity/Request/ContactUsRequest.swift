//
//  ContactUsRequest.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 08/04/2025.
//

import Foundation

struct ContactUsRequest: Codable {
    var name: String? = ""
    var email: String? = ""
    var phone: String? = ""
    var message: String? = ""
}
