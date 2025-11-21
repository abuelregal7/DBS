//
//  MyOrderesRequest.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 12/04/2025.
//

import Foundation

struct MyOrderesRequest: Codable {
    var type: String? = "current" //previous,current
    var limit: Int? = 10
    var page: Int? = 1
}
