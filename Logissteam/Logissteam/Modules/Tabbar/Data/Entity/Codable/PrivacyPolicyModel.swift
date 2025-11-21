//
//  PrivacyPolicyModel.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 02/09/2024.
//

import Foundation

// MARK: - PrivacyPolicyModel
struct PrivacyPolicyModel: Codable {
    let status: Int?
    let message: String?
    let data: PrivacyPolicyData?
    

    enum CodingKeys: String, CodingKey {
        case status, message, data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(Int.self, forKey: .status)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        data = try container.decodeIfPresent(PrivacyPolicyData.self, forKey: .data)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(message, forKey: .message)
        try container.encodeIfPresent(data, forKey: .data)
    }
}

// MARK: - PrivacyPolicyData
struct PrivacyPolicyData: Codable {
    let id: Int?
    let body: String?
    let image: String?
    

    enum CodingKeys: String, CodingKey {
        case id, body, image
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        body = try container.decodeIfPresent(String.self, forKey: .body)
        image = try container.decodeIfPresent(String.self, forKey: .image)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(body, forKey: .body)
        try container.encodeIfPresent(image, forKey: .image)
    }
}
