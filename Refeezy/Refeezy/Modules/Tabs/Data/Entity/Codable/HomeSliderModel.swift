//
//  HomeSliderModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 05/04/2025.
//

import Foundation

// MARK: - HomeSliderModel
struct HomeSliderModel: Codable {
    let status: Int?
    let message: String?
    let data: [HomeSliderData]?
}

// MARK: - HomeSliderData
struct HomeSliderData: Codable {
    let id: Int?
    let image: String?
    let type: String?
    let roomID: Int?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case id, image, type
        case roomID = "room_id"
        case url
    }
}
