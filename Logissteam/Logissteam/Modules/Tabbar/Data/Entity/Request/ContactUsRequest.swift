//
//  ContactUsRequest.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 01/09/2024.
//

import Foundation

struct ContactUsRequest: Codable {
    var first_name: String? = ""
    var last_name: String? = ""
    var email: String? = ""
    var message: String? = ""
}
