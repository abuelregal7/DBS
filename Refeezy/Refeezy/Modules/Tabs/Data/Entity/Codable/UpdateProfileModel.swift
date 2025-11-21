//
//  UpdateProfileModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 08/04/2025.
//

import Foundation

// MARK: - UpdateProfileModel
struct UpdateProfileModel: Codable {
    let status: Int?
    let message: String?
    let data: UpdateProfileData?
}

// MARK: - UpdateProfileData
struct UpdateProfileData: Codable {
    let id: Int?
    let name, email, phone: String?
    let image: String?
}
