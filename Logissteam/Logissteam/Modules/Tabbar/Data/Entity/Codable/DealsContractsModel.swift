//
//  DealsContractsModel.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 25/09/2024.
//

import Foundation

// MARK: - DealsContractsModel
struct DealsContractsModel: Codable {
    let status: Int?
    let message: String?
    let data: DealsContractsData?
}

// MARK: - DealsContractsData
struct DealsContractsData: Codable {
    let data: [DealsContractData]?
    let links: DealsContractsLinks?
    let meta: DealsContractsMeta?
}

// MARK: - Datum
struct DealsContractData: Codable {
    let id: Int?
    let title: String?
    let attachment: String?
}

// MARK: - Links
struct DealsContractsLinks: Codable {
    let first, last: String?
    let prev, next: String?
}

// MARK: - Meta
struct DealsContractsMeta: Codable {
    let currentPage, from, lastPage: Int?
    let links: [DealsContractsLink]?
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
struct DealsContractsLink: Codable {
    let url: String?
    let label: String?
    let active: Bool?
}
