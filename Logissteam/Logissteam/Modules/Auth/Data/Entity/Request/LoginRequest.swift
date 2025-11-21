//
//  LoginRequest.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 20/08/2024.
//

import Foundation

struct LoginRequest: Codable {
    var phone: String? = ""
    var fcm_token: String?
    var platform: String? = "ios"
}
