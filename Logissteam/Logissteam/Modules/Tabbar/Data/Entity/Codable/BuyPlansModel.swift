//
//  BuyPlansModel.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 25/09/2024.
//

import Foundation

// MARK: - BuyPlansModel
struct BuyPlansModel: Codable {
    let status: Int?
    let message: String?
    let data: [BuyPlansModelData]?
}

    // MARK: - BuyPlansModelData
struct BuyPlansModelData: Codable {
    let id: Int?
    let title: String?
    let monthlyProfit: Double?
    let period, paymentPeriod: Int?
    let firstPaymentPeriod: String?
    let profitPercent: Int?
    let attachment: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case monthlyProfit = "monthly_profit"
        case period
        case paymentPeriod = "payment_period"
        case firstPaymentPeriod = "first_payment_period"
        case profitPercent = "profit_percent"
        case attachment
    }
}
