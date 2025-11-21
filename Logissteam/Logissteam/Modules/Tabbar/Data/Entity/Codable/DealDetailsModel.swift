//
//  DealDetailsModel.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 25/09/2024.
//

import Foundation

// MARK: - DealDetailsModel
struct DealDetailsModel: Codable {
    let status: Int?
    let message: String?
    let data: DealDetailsData?
}

// MARK: - DataClass
struct DealDetailsData: Codable {
    let id: Int?
    let image: [String]?
    let name, desc: String?
    let quantity, reserveDays: Int?
    let price, reservePrice: Double?
    let reserveTerms: String?

    enum CodingKeys: String, CodingKey {
        case id, image, name, desc, quantity, price
        case reservePrice = "reserve_price"
        case reserveDays = "reserve_days"
        case reserveTerms = "reserve_terms"
    }
}
