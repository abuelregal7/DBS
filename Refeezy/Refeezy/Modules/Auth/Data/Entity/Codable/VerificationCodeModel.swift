//
//  VerificationCodeModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 05/04/2025.
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
    let userData: VerificationCodeUserData?

    enum CodingKeys: String, CodingKey {
        case token
        case userData = "user_data"
    }
}

// MARK: - UserData
struct VerificationCodeUserData: Codable {
    let id: Int?
    let name, phone, email: String?
    let image: String?
    let fcmToken, platform, emailVerifiedAt: String?
    let manualDelete, isActive: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, phone, email, image
        case fcmToken = "fcm_token"
        case platform
        case emailVerifiedAt = "email_verified_at"
        case manualDelete = "manual_delete"
        case isActive = "is_active"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
