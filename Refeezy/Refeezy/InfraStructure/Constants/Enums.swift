//
//  Enums.swift
//  Maintenance
//
//  Created by Ahmed abuelregal on 02/12/2023.
//

import UIKit

enum AppLanguage: Int {
    case english = 1
    case arabic = 2
    
    var languageIdentifier: String {
        switch self {
        case .arabic:
            return "ar"
        case .english:
            return "en"
        }
    }
    
    init?(languageIdentifier: String) {
        switch languageIdentifier {
        case "en":
            self = .english
        case "ar":
            self = .arabic
        default:
            return nil
        }
    }
}

