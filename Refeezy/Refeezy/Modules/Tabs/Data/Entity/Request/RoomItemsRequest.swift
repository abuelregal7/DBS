//
//  RoomItemsRequest.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 12/04/2025.
//

import Foundation

struct RoomItemsRequest: Codable {
    var id: Int?
    var limit: Int? = 10
    var page: Int? = 1
}
