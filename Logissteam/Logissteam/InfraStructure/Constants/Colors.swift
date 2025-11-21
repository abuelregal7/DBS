//
//  Colors.swift
//  Maintenance
//
//  Created by Ahmed abuelregal on 02/12/2023.
//

import UIKit

extension UIColor {
    
    static var PrimaryOrange: UIColor {
        return color(name: "PrimaryOrange")
    }
    
    static var PrimaryYellow: UIColor {
        return color(name: "PrimaryYellow")
    }
    
    static var PrimaryDarkGreen: UIColor {
        return color(name: "PrimaryDarkGreen")
    }
    
    static var PrimaryBlue: UIColor {
        return color(name: "PrimaryBlue")
    }
    
    static var PrimarySixthGray: UIColor {
        return color(name: "PrimarySixthGray")
    }
    
    private static func color(name: String) -> UIColor {
        return UIColor.init(named: name) ?? UIColor.white
    }
}
