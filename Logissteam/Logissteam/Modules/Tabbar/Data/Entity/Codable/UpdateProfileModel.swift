//
//  UpdateProfileModel.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 02/09/2024.
//

import Foundation

// MARK: - UpdateProfileModel
struct UpdateProfileModel: Codable {
    let status: Int?
    let message: String?
    

    enum CodingKeys: String, CodingKey {
        case status, message
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(Int.self, forKey: .status)
        message = try container.decodeIfPresent(String.self, forKey: .message)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(message, forKey: .message)
    }
}
