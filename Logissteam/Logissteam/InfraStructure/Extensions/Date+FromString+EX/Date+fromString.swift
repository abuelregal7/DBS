//
//  Date+fromString.swift
//  BaseProgect
//
//  Created by Restart Technology on 15/09/2022.
//
import Foundation

extension Date {
    static func from(string date: String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.date(from: date)
    }
    
    func toString(format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale =  Locale(identifier: "en") //Language.currentLanguage.languageIdentifier
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func toStringWithLang(format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        print(Language.currentLanguage.languageIdentifier)
        dateFormatter.locale =  Locale(identifier: Language.currentLanguage.languageIdentifier)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}

extension Date {
    func dateStringWith(strFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale =  Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = strFormat
        return dateFormatter.string(from: self)
    }
}
