//
//  LoginModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 04/04/2025.
//

import Foundation

// MARK: - LoginModel
struct LoginModel: Codable {
    let status: Int?
    let message: String?
    let data: LoginData?
}

// MARK: - DataClass
struct LoginData: Codable {
    let otp: Int?
}
