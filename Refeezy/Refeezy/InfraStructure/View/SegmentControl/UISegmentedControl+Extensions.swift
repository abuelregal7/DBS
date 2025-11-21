//
//  UISegmentedControl+Extensions.swift
//  OrderFulfillment
//
//  Created by Islam Rahiem on 11/05/2023.
//

import UIKit

extension UISegmentedControl {
    
    func removeBackgroundAndTintColor() {
        //Tint
        self.selectedSegmentTintColor = UIColor.clear
        
        //Background
        if #available(iOS 13.0, *) {
          let image = UIImage()
          let size = CGSize(width: 1, height: self.intrinsicContentSize.height)
          UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
          image.draw(in: CGRect(origin: .zero, size: size))
          let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
            self.setBackgroundImage(scaledImage, for: .normal, barMetrics: .default)
            self.setDividerImage(scaledImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        }
    }
    
    func setNormalTitleColor(_ color: UIColor = .black) {
        self.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.appFont(ofSize: 13, weight: .regular)!,
            NSAttributedString.Key.foregroundColor: color
        ], for: .normal)
    }
    
    func setSelectedTitleColor(_ color: UIColor = .black) {
        self.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.appFont(ofSize: 13, weight: .semibold)!,
            NSAttributedString.Key.foregroundColor: color
        ], for: .selected)
    }
}
