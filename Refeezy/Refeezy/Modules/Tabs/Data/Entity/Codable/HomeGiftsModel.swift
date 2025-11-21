//
//  HomeGiftsModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 05/04/2025.
//

import Foundation

// MARK: - HomeGiftsModel
struct HomeGiftsModel: Codable {
    let status: Int?
    let message: String?
    let data: [HomeGiftsData]?
}

// MARK: - HomeGiftsModelData
struct HomeGiftsData: Codable {
    let id: Int?
    let image: String?
    let title: String?
}
