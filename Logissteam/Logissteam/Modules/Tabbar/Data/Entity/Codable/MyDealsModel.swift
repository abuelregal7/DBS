//
//  MyDealsModel.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 25/09/2024.
//

import Foundation

// MARK: - MyDealsModel
struct MyDealsModel: Codable {
    let status: Int?
    let message: String?
    let data: MyDealsData?
}

// MARK: - DataClass
struct MyDealsData: Codable {
    let data: [MyDealData]?
    let links: MyDealsLinks?
    let meta: MyDealsMeta?
}

// MARK: - Datum
struct MyDealData: Codable {
    let id, dealID: Int?
    let image: String?
    let name, desc: String?
    let quantity: Int?
    let price, totalPrice, nextPaymentAmount: Double?
    let paymentMethod, paymentStatus: String?
    let nextPaymentDate, status, type: String?

    enum CodingKeys: String, CodingKey {
        case id
        case dealID = "deal_id"
        case image, name, desc, quantity, price
        case totalPrice = "total_price"
        case paymentMethod = "payment_method"
        case paymentStatus = "payment_status"
        case nextPaymentAmount = "next_payment_amount"
        case nextPaymentDate = "next_payment_date"
        case status, type
    }
}

// MARK: - Links
struct MyDealsLinks: Codable {
    let first, last: String?
    let prev, next: String?
}

// MARK: - Meta
struct MyDealsMeta: Codable {
    let currentPage, from, lastPage: Int?
    let links: [MyDealsLink]?
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
struct MyDealsLink: Codable {
    let url: String?
    let label: String?
    let active: Bool?
}
