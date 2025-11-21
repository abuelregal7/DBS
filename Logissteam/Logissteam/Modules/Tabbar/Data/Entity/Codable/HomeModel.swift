//
//  HomeModel.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 20/08/2024.
//

import Foundation

// MARK: - HomeModel
struct HomeModel: Codable {
    let status: Int?
    let message: String?
    let data: HomeData?

    enum CodingKeys: String, CodingKey {
        case status, message, data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(Int.self, forKey: .status)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        data = try container.decodeIfPresent(HomeData.self, forKey: .data)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(message, forKey: .message)
        try container.encodeIfPresent(data, forKey: .data)
    }
}

// MARK: - HomeData
struct HomeData: Codable {
    let sliders: [HomeSlider]?
    let deals: HomeDeals?

    enum CodingKeys: String, CodingKey {
        case sliders, deals
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sliders = try container.decodeIfPresent([HomeSlider].self, forKey: .sliders)
        deals = try container.decodeIfPresent(HomeDeals.self, forKey: .deals)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(sliders, forKey: .sliders)
        try container.encodeIfPresent(deals, forKey: .deals)
    }
}

// MARK: - HomeDeals
struct HomeDeals: Codable {
    let data: [HomeDealsData]?
    let links: HomeLinks?
    let meta: HomeMeta?

    enum CodingKeys: String, CodingKey {
        case data, links, meta
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decodeIfPresent([HomeDealsData].self, forKey: .data)
        links = try container.decodeIfPresent(HomeLinks.self, forKey: .links)
        meta = try container.decodeIfPresent(HomeMeta.self, forKey: .meta)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(data, forKey: .data)
        try container.encodeIfPresent(links, forKey: .links)
        try container.encodeIfPresent(meta, forKey: .meta)
    }
}

// MARK: - HomeDealsData
struct HomeDealsData: Codable {
    let id: Int?
    let image: String?
    let name, desc: String?
    let quantity: Int?
    let price, reservePrice: Double?

    enum CodingKeys: String, CodingKey {
        case id, image, name, desc, quantity, price
        case reservePrice = "reserve_price"
    }

    // Custom initializer for decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        image = try container.decodeIfPresent(String.self, forKey: .image)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        desc = try container.decodeIfPresent(String.self, forKey: .desc)
        quantity = try container.decodeIfPresent(Int.self, forKey: .quantity)
        price = try container.decodeIfPresent(Double.self, forKey: .price)
        reservePrice = try container.decodeIfPresent(Double.self, forKey: .reservePrice)
    }

    // Custom encode function for encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(image, forKey: .image)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(desc, forKey: .desc)
        try container.encodeIfPresent(quantity, forKey: .quantity)
        try container.encodeIfPresent(price, forKey: .price)
        try container.encodeIfPresent(reservePrice, forKey: .reservePrice)
    }
}

// MARK: - Links
struct HomeLinks: Codable {
    let first, last: String?
    let prev, next: String?

    enum CodingKeys: String, CodingKey {
        case first, last, prev, next
    }

    // Custom initializer for decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        first = try container.decodeIfPresent(String.self, forKey: .first)
        last = try container.decodeIfPresent(String.self, forKey: .last)
        prev = try container.decodeIfPresent(String.self, forKey: .prev)
        next = try container.decodeIfPresent(String.self, forKey: .next)
    }

    // Custom encode function for encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(first, forKey: .first)
        try container.encodeIfPresent(last, forKey: .last)
        try container.encodeIfPresent(prev, forKey: .prev)
        try container.encodeIfPresent(next, forKey: .next)
    }
}

// MARK: - Meta
struct HomeMeta: Codable {
    let currentPage, from, lastPage: Int?
    let links: [HomeLink]?
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

    // Custom initializer for decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currentPage = try container.decodeIfPresent(Int.self, forKey: .currentPage)
        from = try container.decodeIfPresent(Int.self, forKey: .from)
        lastPage = try container.decodeIfPresent(Int.self, forKey: .lastPage)
        links = try container.decodeIfPresent([HomeLink].self, forKey: .links)
        path = try container.decodeIfPresent(String.self, forKey: .path)
        perPage = try container.decodeIfPresent(Int.self, forKey: .perPage)
        to = try container.decodeIfPresent(Int.self, forKey: .to)
        total = try container.decodeIfPresent(Int.self, forKey: .total)
    }

    // Custom encode function for encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(currentPage, forKey: .currentPage)
        try container.encodeIfPresent(from, forKey: .from)
        try container.encodeIfPresent(lastPage, forKey: .lastPage)
        try container.encodeIfPresent(links, forKey: .links)
        try container.encodeIfPresent(path, forKey: .path)
        try container.encodeIfPresent(perPage, forKey: .perPage)
        try container.encodeIfPresent(to, forKey: .to)
        try container.encodeIfPresent(total, forKey: .total)
    }
}

// MARK: - Link
struct HomeLink: Codable {
    let url: String?
    let label: String?
    let active: Bool?

    enum CodingKeys: String, CodingKey {
        case url, label, active
    }

    // Custom initializer for decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        label = try container.decodeIfPresent(String.self, forKey: .label)
        active = try container.decodeIfPresent(Bool.self, forKey: .active)
    }

    // Custom encode function for encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(url, forKey: .url)
        try container.encodeIfPresent(label, forKey: .label)
        try container.encodeIfPresent(active, forKey: .active)
    }
}

// MARK: - Slider
struct HomeSlider: Codable {
    let id: Int?
    let image: String?
    let type: String?
    let dealID: Int?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case id, image, type
        case dealID = "deal_id"
        case url
    }

    // Custom initializer for decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        image = try container.decodeIfPresent(String.self, forKey: .image)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        dealID = try container.decodeIfPresent(Int.self, forKey: .dealID)
        url = try container.decodeIfPresent(String.self, forKey: .url)
    }

    // Custom encode function for encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(image, forKey: .image)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(dealID, forKey: .dealID)
        try container.encodeIfPresent(url, forKey: .url)
    }
}
