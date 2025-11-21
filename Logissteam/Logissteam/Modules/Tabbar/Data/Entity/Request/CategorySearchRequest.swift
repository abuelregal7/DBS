//
//  CategorySearchRequest.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 08/09/2024.
//

import Foundation

struct CategorySearchRequest: Codable {
    var search: String?
    var page: Int = 1
}
