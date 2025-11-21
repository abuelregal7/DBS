//
//  ShowOrdereModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 12/04/2025.
//

import Foundation

// MARK: - ShowOrdereModel
struct ShowOrdereModel: Codable {
    let status: Int?
    let message: String?
    let data: ShowOrdereData?
}

// MARK: - ShowOrdereData
struct ShowOrdereData: Codable {
    let id, subTotal, discount, voucherCode: Int?
    let status, paymentStatus: String?
    let shippingCost, tax, total: Int?
    let deliveryType: String?
    let address: ShowOrdereAddress?
    let warehouse: ShowOrdereWarehouse?
    let itemsCount: Int?
    let room: ShowOrdereRoom?
    let roomItems: [ShowOrdereRoomItem]?

    enum CodingKeys: String, CodingKey {
        case id
        case subTotal = "sub_total"
        case discount
        case voucherCode = "voucher_code"
        case status
        case paymentStatus = "payment_status"
        case shippingCost = "shipping_cost"
        case tax, total
        case deliveryType = "delivery_type"
        case address, warehouse
        case itemsCount = "items_count"
        case room
        case roomItems = "room_items"
    }
}

// MARK: - AShowOrdereddress
struct ShowOrdereAddress: Codable {
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

// MARK: - ShowOrdereRoom
struct ShowOrdereRoom: Codable {
    let id: Int?
    let image: String?
    let title, description: String?
    let price: Int?
    let expiredAt: String?
    let isAvailable, productCount, remainCount: Int?
    let superGift: ShowOrdereGift?
    let winnerItem: ShowOrdereWinnerItem?

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

// MARK: - ShowOrdereGift
struct ShowOrdereGift: Codable {
    let id: Int?
    let image: String?
    let title: String?
}

// MARK: - ShowOrdereWinnerItem
struct ShowOrdereWinnerItem: Codable {
    let id: Int?
    let itemNumber, user: String?
    let gift: ShowOrdereGift?

    enum CodingKeys: String, CodingKey {
        case id
        case itemNumber = "item_number"
        case user, gift
    }
}

// MARK: - RShowOrdereoomItem
struct ShowOrdereRoomItem: Codable {
    let id, itemNum, price: Int?
    let itemGift: ShowOrdereGift?

    enum CodingKeys: String, CodingKey {
        case id
        case itemNum = "item_num"
        case price
        case itemGift = "item_gift"
    }
}

// MARK: - ShowOrdereWarehouse
struct ShowOrdereWarehouse: Codable {
    let id: Int?
    let title, address, lat, lng: String?
}
