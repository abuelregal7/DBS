//
//  Constants.swift
//  Maintenance
//
//  Created by Ahmed abuelregal on 02/12/2023.
//

import Foundation

final class Constants {
    static var baseURL = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as! String
    static var moyasarAPIKiy = Bundle.main.object(forInfoDictionaryKey: "MoyasarAPIKey") as! String
    static var merchantIdentifier = Bundle.main.object(forInfoDictionaryKey: "MerchantIdentifier") as! String
}
