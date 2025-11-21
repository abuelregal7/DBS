//
//  SettingModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 17/04/2025.
//

import Foundation

// MARK: - SettingModel
struct SettingModel: Codable {
    let status: Int?
    let message: String?
    let data: [SettingData]?
}

// MARK: - SettingData
struct SettingData: Codable {
    let id: Int?
    let key: String?
    let value: String?
    let image: String?
}
