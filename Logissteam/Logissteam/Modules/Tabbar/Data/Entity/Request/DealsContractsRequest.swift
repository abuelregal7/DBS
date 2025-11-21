//
//  DealsContractsRequest.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 25/09/2024.
//

import Foundation

struct DealsContractsRequest: Codable {
    var user_deal_id: Int?
    var page: Int = 1
}
