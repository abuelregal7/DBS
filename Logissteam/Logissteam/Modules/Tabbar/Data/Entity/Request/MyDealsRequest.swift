//
//  MyDealsRequest.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 25/09/2024.
//

import Foundation

struct MyDealsRequest: Codable {
    var type: String? = "current" //current | previous
    var page: Int = 1
}
