//
//  RegisterModel.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 01/09/2024.
//

import Foundation

// MARK: - RegisterModel
struct RegisterModel: Codable {
    let status: Int?
    let message: String?
    let data: RegisterData?
}

// MARK: - DataClass
struct RegisterData: Codable {
    let otp: Int?
}
