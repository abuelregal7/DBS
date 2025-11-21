//
//  VerificationCodeRequest.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 05/04/2025.
//

import Foundation

struct VerificationCodeRequest: Codable {
    var phone: String?
    var token: String?
    var fcm_token: String? = UD.FCMToken
    var platform: String? = "ios"
}
