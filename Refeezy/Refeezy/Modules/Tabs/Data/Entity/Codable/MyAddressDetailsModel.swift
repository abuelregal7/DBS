//
//  MyAddressDetailsModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 08/04/2025.
//

import Foundation

// MARK: - MyAddressDetailsModel
struct MyAddressDetailsModel: Codable {
    let status: Int?
    let message: String?
    let data: MyAddressDetailsData?
}

// MARK: - MyAddressDetailsData
struct MyAddressDetailsData: Codable {
    let id: Int?
    let address, city, postalCode, phone: String?
    let lat, lng: String?
    let isDefault: Int?

    enum CodingKeys: String, CodingKey {
        case id, address, city
        case postalCode = "postal_code"
        case phone, lat, lng
        case isDefault = "is_default"
    }
}
