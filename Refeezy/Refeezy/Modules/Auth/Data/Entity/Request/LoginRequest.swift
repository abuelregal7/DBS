//
//  LoginRequest.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 04/04/2025.
//

import Foundation

struct LoginRequest: Codable {
    var phone: String?
    var fcm_token: String? = UD.FCMToken
    var platform: String? = "ios"
}
