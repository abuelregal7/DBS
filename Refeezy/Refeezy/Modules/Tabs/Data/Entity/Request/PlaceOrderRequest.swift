//
//  PlaceOrderRequest.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 20/04/2025.
//

import Foundation

struct PlaceOrderRequest: Codable {
    var room_id: Int?
    var item_ids: [Int]?
    var delivery_type: String? = "address" //address, warehouse
    var address_id: Int? //1
    var warehouse_id: Int? //2
    
}
