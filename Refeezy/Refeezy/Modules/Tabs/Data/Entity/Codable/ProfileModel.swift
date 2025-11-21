//
//  ProfileModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 08/04/2025.
//

import Foundation

// MARK: - ProfileModel
struct ProfileModel: Codable {
    let status: Int?
    let message: String?
    let data: ProfileData?
}

// MARK: - ProfileData
struct ProfileData: Codable {
    let id: Int?
    let name, email, phone: String?
    let image: String?
}
