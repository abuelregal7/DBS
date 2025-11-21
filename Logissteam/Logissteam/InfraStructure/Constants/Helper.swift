//
//  Constants.swift
//  BonTech
//
//  Created by Ahmed Abo Al-Regal on 02/10/2023.
//

import UIKit

var deviceHasHomeBottom: Bool {
    if UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20 {
        return false
    }
    return true
}

func creatLabel(text: String? = nil,
                textcolor: UIColor = DesignSystem.Colors.PrimaryGray.color,
                ofSize size: CGFloat = 13,
                weight: UIFont.Weight = .regular) -> UILabel {
    let label = UILabel()
    label.font = .appFont(ofSize: size, weight: weight)
    label.text = text
    label.textColor = textcolor
    label.textAlignment = Language.currentAppleLanguage() == "ar" ? .right : .left
    return label
}
