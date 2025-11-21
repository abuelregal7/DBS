//
//  String_Ext.swift
//  Maintenance
//
//  Created by Ahmed abuelregal on 02/12/2023.
//

import Foundation
import UIKit

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        let range = start..<end
        return String(self[range])
    }
    
    func charAt(at: Int) -> Character {
        let charIndex = self.index(self.startIndex, offsetBy: at)
        return self[charIndex]
    }
    
    //Localize
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    // Numbers
    var intValue : Int {
        let arr = ["٠","١","٢","٣","٤","٥","٦","٧","٨","٩"]
        var result = self
        for int in 0...9 {
            result = result.replacingOccurrences(of: arr[int], with:String(int) )
        }
        result = result.replacingOccurrences(of: " \("SAR".localized)", with:"" )
        
        return Int(result) ?? 0
    }
    
    var doubleValue: Double {
        return Double(self) ?? 0.0
    }
    
    var floatValue: Float {
        return Float(self) ?? 0.0
    }

    //Base64
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
    
    func absoluteBase64() -> String {
        if let string = components(separatedBy: "base64,").last, components(separatedBy: "base64,").count == 2 {
            return string
        }
        return self
    }
    
    func string(format: String, identifier: Calendar.Identifier = .gregorian, locale: String = "en") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Language.currentLanguage.languageIdentifier)
        formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss'Z'"
        formatter.calendar = Calendar(identifier: identifier)
        let date = formatter.date(from: self) ?? Date()
        formatter.dateFormat = format
        formatter.timeZone = .current
        return formatter.string(from: date)
    }
    
    func addStars(numOfVisibleChar: Int = 2) -> String {
        let visibleDigits = max(self.count - numOfVisibleChar, 0)
        let maskedDigits = String(repeating: "*", count: visibleDigits)
        let lastFourDigits = String(self.suffix(numOfVisibleChar))
        let maskedPhoneNumber = maskedDigits + lastFourDigits
        return maskedPhoneNumber
    }
}

extension String {
    var toDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        dateFormatter.locale = .autoupdatingCurrent
        guard let date = dateFormatter.date(from: self) else {return Date()}
        return date
    }
    
    func arabicToEnglishDigits() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "EN")
        let formatted = numberFormatter.number(from: self) ?? 0
        let newPhone = "\(formatted)"
        if (self.first == "0" || self.first == "٠") && newPhone.first != "0" {
            return "0\(newPhone)"
        } else {
            return newPhone
        }
    }
}
