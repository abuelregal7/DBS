//
//  VerificationCodeModel.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 01/09/2024.
//

import Foundation

// MARK: - VerificationCodeModel
struct VerificationCodeModel: Codable {
    let status: Int?
    let message: String?
    let data: VerificationCodeData?
}

// MARK: - DataClass
struct VerificationCodeData: Codable {
    let token: String?
    let userData: UserData?

    enum CodingKeys: String, CodingKey {
        case token
        case userData = "user_data"
    }
}

// MARK: - UserData
struct UserData: Codable {
    let id: Int?
    let name, email, phone: String?
    let ibanImage: String?
    let emailVerifiedAt, fcmToken, platform: String? //, loginCode
    let isActive: Int?
    let lang, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email, phone
        case ibanImage = "iban_image"
        case emailVerifiedAt = "email_verified_at"
        case fcmToken = "fcm_token"
        case platform
        //case loginCode = "login_code"
        case isActive = "is_active"
        case lang
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
