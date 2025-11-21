//
//  RoomDetailsModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 12/04/2025.
//

import Foundation

// MARK: - RoomDetailsModel
struct RoomDetailsModel: Codable {
    let status: Int?
    let message: String?
    let data: RoomDetailsData?
}

// MARK: - RoomDetailsData
struct RoomDetailsData: Codable {
    let id: Int?
    let image: String?
    let title, description: String?
    let price: Double?
    let expiredAt: String?
    let isAvailable, productCount, remainCount: Int?
    let superGift: RoomDetailsGift?
    let product: RoomDetailsProduct?
    let warehouse: RoomDetailsWarehouse?
    let winnerItem: RoomDetailsWinnerItem?

    enum CodingKeys: String, CodingKey {
        case id, image, title, description, price
        case expiredAt = "expired_at"
        case isAvailable = "is_available"
        case productCount = "product_count"
        case remainCount = "remain_count"
        case superGift = "super_gift"
        case product, warehouse
        case winnerItem = "winner_item"
    }
}

// MARK: - RoomDetailsProduct
struct RoomDetailsProduct: Codable {
    let id: Int?
    let images: [String]?
    let title, description: String?
}

// MARK: - RoomDetailsGift
struct RoomDetailsGift: Codable {
    let id: Int?
    let image: String?
    let title: String?
}

// MARK: - RoomDetailsWarehouse
struct RoomDetailsWarehouse: Codable {
    let id: Int?
    let title, address, lat, lng: String?
}

// MARK: - RoomDetailsWinnerItem
struct RoomDetailsWinnerItem: Codable {
    let id: Int?
    let itemNumber, user: String?
    let gift: RoomDetailsGift?

    enum CodingKeys: String, CodingKey {
        case id
        case itemNumber = "item_number"
        case user, gift
    }
}
