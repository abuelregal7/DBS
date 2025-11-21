//
//  DealsPaymentsModel.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 25/09/2024.
//

import Foundation

// MARK: - DealsPaymentsModel
struct DealsPaymentsModel: Codable {
    let status: Int?
    let message: String?
    let data: DealsPaymentsData?
}

// MARK: - DealsPaymentsData
struct DealsPaymentsData: Codable {
    let data: [DealsPaymentData]?
    let links: DealsPaymentsLinks?
    let meta: DealsPaymentsMeta?
}

// MARK: - Datum
struct DealsPaymentData: Codable {
    let id: Int?
    let amount: Double?
    let dueDate, status, attachment: String?

    enum CodingKeys: String, CodingKey {
        case id, amount
        case dueDate = "due_date"
        case status, attachment
    }
}

// MARK: - Links
struct DealsPaymentsLinks: Codable {
    let first, last: String?
    let prev, next: String?
}

// MARK: - Meta
struct DealsPaymentsMeta: Codable {
    let currentPage, from, lastPage: Int?
    let links: [DealsPaymentsLink]?
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
struct DealsPaymentsLink: Codable {
    let url: String?
    let label: String?
    let active: Bool?
}
