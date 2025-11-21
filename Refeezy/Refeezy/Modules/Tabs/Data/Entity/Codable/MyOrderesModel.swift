//
//  MyOrderesModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 12/04/2025.
//

import Foundation

// MARK: - MyOrderesModel
struct MyOrderesModel: Codable {
    let status: Int?
    let message: String?
    let data: MyOrderesData?
}

// MARK: - MyOrdereData
struct MyOrderesData: Codable {
    let data: [MyOrderesDataData]?
    let links: MyOrderesLinks?
    let meta: MyOrderesMeta?
}

// MARK: - MyOrderesDataData
struct MyOrderesDataData: Codable {
    let id: Int?
    let room: MyOrderesRoom?
    let roomItems: [MyOrderesRoomItem]?

    enum CodingKeys: String, CodingKey {
        case id, room
        case roomItems = "room_items"
    }
}

// MARK: - MyOrderesRoom
struct MyOrderesRoom: Codable {
    let id: Int?
    let image: String?
    let title, description: String?
    let price: Int?
    let expiredAt: String?
    let isAvailable, productCount, remainCount: Int?
    let superGift: MyOrderesGift?
    let winnerItem: MyOrderesWinnerItem?

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

// MARK: - MyOrderesGift
struct MyOrderesGift: Codable {
    let id: Int?
    let image: String?
    let title: String?
}

// MARK: - MyOrderesWinnerItem
struct MyOrderesWinnerItem: Codable {
    let id: Int?
    let itemNumber, user: String?
    let gift: MyOrderesGift?

    enum CodingKeys: String, CodingKey {
        case id
        case itemNumber = "item_number"
        case user, gift
    }
}

// MARK: - MyOrdereRoomItem
struct MyOrderesRoomItem: Codable {
    let id, itemNum, price: Int?
    let itemGift: MyOrderesGift?

    enum CodingKeys: String, CodingKey {
        case id
        case itemNum = "item_num"
        case price
        case itemGift = "item_gift"
    }
}

// MARK: - MyOrderesLinks
struct MyOrderesLinks: Codable {
    let first, last: String?
    let prev, next: String?
}

// MARK: - MyOrderesMeta
struct MyOrderesMeta: Codable {
    let currentPage, from, lastPage: Int?
    let links: [MyOrderesLink]?
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

// MARK: - MyOrderesLink
struct MyOrderesLink: Codable {
    let url: String?
    let label: String?
    let active: Bool?
}
