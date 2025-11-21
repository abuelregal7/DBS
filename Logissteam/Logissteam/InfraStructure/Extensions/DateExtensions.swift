//
//  DateExtensions.swift
//  KACST
//
//  Created by Mahmoud Eissa on 10/22/18.
//  Copyright © 2018 Mahmoud Eissa. All rights reserved.
//

import UIKit

extension Date {
    func string(format: String, identifier: Calendar.Identifier = .gregorian, locale: String = Language.currentLanguage.languageIdentifier) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: Language.currentLanguage.languageIdentifier)
        formatter.calendar = Calendar(identifier: identifier)
        return formatter.string(from: self)
    }
    
    func stringForCalender(format: String, identifier: Calendar.Identifier = .gregorian, locale: String = Language.currentLanguage.languageIdentifier) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: Language.currentLanguage.languageIdentifier)
        formatter.timeZone = .current
        return formatter.string(from: self)
    }
    
    //MARK: Date Formate
    func toDayMonthOnly() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
}
