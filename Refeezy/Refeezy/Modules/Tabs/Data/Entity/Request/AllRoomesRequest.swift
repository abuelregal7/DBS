//
//  AllRoomesRequest.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 07/04/2025.
//

import Foundation

struct AllRoomesRequest: Codable {
    var search: String?
    var limit: Int? = 10
    var page: Int? = 1
}
