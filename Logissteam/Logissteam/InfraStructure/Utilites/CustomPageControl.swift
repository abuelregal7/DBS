//
//  CustomPageControl.swift
//  Wala
//
//  Created by Ahmed Abo Al-Regal on 13/02/2024.
//

import Foundation
import UIKit

class CustomPageControl: UIView {
    private var pageImageViews: [UIImageView] = []
    
    var numberOfPages: Int = 0 {
        didSet {
            setupPageImageViews()
        }
    }
    
    var currentPage: Int = 0 {
        didSet {
            updatePageImages()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Set the semantic content attribute to force RTL layout
        if #available(iOS 9.0, *) {
            if Language.currentAppleLanguage() == "ar" {
                self.semanticContentAttribute = .forceRightToLeft
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Set the semantic content attribute to force RTL layout
        if #available(iOS 9.0, *) {
            if Language.currentAppleLanguage() == "ar" {
                self.semanticContentAttribute = .forceRightToLeft
            }
        }
    }
    
    private func setupPageImageViews() {
        // Remove any existing page image views
        for imageView in pageImageViews {
            imageView.removeFromSuperview()
        }
        
        pageImageViews = []
        
        let imageSize: CGFloat = 15.0
        let spacing: CGFloat = 10.0
        let totalWidth = CGFloat(numberOfPages) * imageSize + CGFloat(numberOfPages - 1) * spacing
        let startX = (self.frame.width - totalWidth) / 2.0
        
        for i in 0..<numberOfPages {
            // Adjust X position for RTL layout
            let imageViewX = (self.semanticContentAttribute == .forceRightToLeft) ? startX + totalWidth - CGFloat(i + 1) * (imageSize + spacing) : startX + CGFloat(i) * (imageSize + spacing)
            
            let imageView = UIImageView(frame: CGRect(x: imageViewX, y: 0, width: imageSize, height: imageSize))
            imageView.image = UIImage(named: "Swipe Dot un selected") // Set your inactive image here
            addSubview(imageView)
            pageImageViews.append(imageView)
        }
        
        updatePageImages()
    }
    
    private func updatePageImages() {
        for (index, imageView) in pageImageViews.enumerated() {
            imageView.image = (index == currentPage) ? UIImage(named: "Swipe Dot") : UIImage(named: "Swipe Dot un selected")
        }
    }
}
