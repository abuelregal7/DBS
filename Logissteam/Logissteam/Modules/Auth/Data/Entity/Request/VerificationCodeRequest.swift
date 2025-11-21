//
//  VerificationCodeRequest.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 01/09/2024.
//

import Foundation

struct VerificationCodeRequest: Codable {
    var phone: String? = ""
    var token: String? = ""
    var fcm_token: String? = ""
    var platform: String? = "ios"
}
