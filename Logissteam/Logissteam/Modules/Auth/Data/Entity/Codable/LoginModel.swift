//
//  LoginModel.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 20/08/2024.
//

import Foundation

// MARK: - LoginModel
struct LoginModel: Codable {
    let status: Int?
    let message: String?
    let data: LoginData?
}

// MARK: - LoginData
struct LoginData: Codable {
    let otp: Int?
}
