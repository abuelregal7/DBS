//
//  RegisterModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 05/04/2025.
//

import Foundation

// MARK: - RegisterModel
struct RegisterModel: Codable {
    let status: Int?
    let message: String?
    let data: RegisterData?
}

// MARK: - RegisterData
struct RegisterData: Codable {
    let otp: Int?
}
