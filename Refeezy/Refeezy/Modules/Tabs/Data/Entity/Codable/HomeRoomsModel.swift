//
//  HomeRoomsModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 05/04/2025.
//

import Foundation

// MARK: - HomeRoomsModel
struct HomeRoomsModel: Codable {
    let status: Int?
    let message: String?
    let data: [HomeRoomsData]?
}

// MARK: - HomeRoomsData
struct HomeRoomsData: Codable {
    let id: Int?
    let image: String?
    let title, description: String?
    let price: Int?
    let expiredAt: String?
    let isAvailable, productCount, remainCount: Int?
    let superGift: HomeRoomsGift?
    let winnerItem: HomeRoomsWinnerItem?

    enum CodingKeys: String, CodingKey {
        case id, image, title, description, price
        case expiredAt = "expired_at"
        case isAvailable = "is_available"
        case productCount = "product_count"
        case remainCount = "remain_count"
        case superGift = "super_gift"
        case winnerItem = "winner_item"
    }
}

// MARK: - HomeRoomsGift
struct HomeRoomsGift: Codable {
    let id: Int?
    let image: String?
    let title: String?
}

// MARK: - HomeRoomsWinnerItem
struct HomeRoomsWinnerItem: Codable {
    let id: Int?
    let itemNumber, user: String?
    let gift: HomeRoomsGift?

    enum CodingKeys: String, CodingKey {
        case id
        case itemNumber = "item_number"
        case user, gift
    }
}
