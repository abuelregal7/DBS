//
//  RoomItemsModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 12/04/2025.
//

import Foundation

// MARK: - RoomItemsModel
struct RoomItemsModel: Codable {
    let status: Int?
    let message: String?
    let data: RoomItemsData?
}

// MARK: - RoomItemsData
struct RoomItemsData: Codable {
    let data: [RoomItemsDataData]?
    let links: RoomItemsLinks?
    let meta: RoomItemsMeta?
}

// MARK: - RoomItemsDataData
struct RoomItemsDataData: Codable {
    let id: Int?
    let image: String?
    let itemNumber: String?
    let price: Double?
    let isAvailable: Int?
    var isSelected: Bool? = false

    enum CodingKeys: String, CodingKey {
        case id, image, isSelected, price
        case itemNumber = "item_number"
        case isAvailable = "is_available"
    }
}

// MARK: - Links
struct RoomItemsLinks: Codable {
    let first, last: String?
    let prev, next: String?
}

// MARK: - Meta
struct RoomItemsMeta: Codable {
    let currentPage, from, lastPage: Int?
    let links: [RoomItemsLink]?
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
struct RoomItemsLink: Codable {
    let url: String?
    let label: String?
    let active: Bool?
}
