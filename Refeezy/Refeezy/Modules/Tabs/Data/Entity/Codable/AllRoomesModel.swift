//
//  AllRoomesModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 07/04/2025.
//

import Foundation

// MARK: - AllRoomesModel
struct AllRoomesModel: Codable {
    let status: Int?
    let message: String?
    let data: AllRoomesData?
}

// MARK: - AllRoomesData
struct AllRoomesData: Codable {
    let data: [AllRoomes]?
    let links: AllRoomesLinks?
    let meta: AllRoomesMeta?
}

// MARK: - AllRoomes
struct AllRoomes: Codable {
    let id: Int?
    let image: String?
    let title, description: String?
    let price: Int?
    let expiredAt: String?
    let isAvailable, productCount, remainCount: Int?
    let superGift: AllRoomesGift?
    let winnerItem: AllRoomesWinnerItem?

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

// MARK: - Gift
struct AllRoomesGift: Codable {
    let id: Int?
    let image: String?
    let title: String?
}

// MARK: - WinnerItem
struct AllRoomesWinnerItem: Codable {
    let id: Int?
    let itemNumber, user: String?
    let gift: AllRoomesGift?

    enum CodingKeys: String, CodingKey {
        case id
        case itemNumber = "item_number"
        case user, gift
    }
}

// MARK: - Links
struct AllRoomesLinks: Codable {
    let first, last, prev: String?
    let next: String?
}

// MARK: - Meta
struct AllRoomesMeta: Codable {
    let currentPage, from, lastPage: Int?
    let links: [AllRoomesLink]?
    let path: String?
    let perPage, to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case from
        case lastPage = "last_page"
        case links, path
        case perPage = "per_page"
        case to, total
    }
}

// MARK: - Link
struct AllRoomesLink: Codable {
    let url: String?
    let label: String?
    let active: Bool?
}
