//
//  PlaceOrderModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 20/04/2025.
//

import Foundation

// MARK: - PlaceOrderModel
struct PlaceOrderModel: Codable {
    let status: Int?
    let message: String?
    let data: PlaceOrderData?
}

// MARK: - PlaceOrderData
struct PlaceOrderData: Codable {
    let orderID, orderTotal: Int?

    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case orderTotal = "order_total"
    }
}
