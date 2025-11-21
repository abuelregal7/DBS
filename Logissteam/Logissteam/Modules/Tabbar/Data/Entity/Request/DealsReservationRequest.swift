//
//  DealsReservationRequest.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 05/10/2024.
//

import Foundation

struct DealsReservationRequest: Codable {
    var deal_id: Int?
    var buy_plan_id: Int?
    var payment_method: String?
    var type: String?
}
