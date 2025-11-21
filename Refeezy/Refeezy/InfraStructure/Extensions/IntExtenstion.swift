//
//  DoubleExtenstion.swift
//  Maintenance
//
//  Created by IOS-Zinab on 01/05/2023.
//

import Foundation

extension Int {
    func addCommaToNumber() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedNumber = formatter.string(from: NSNumber(value: self)) ?? ""
        return formattedNumber
    }
}
