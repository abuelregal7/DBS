//
//  SegmentView.swift
//  FriendyOwner
//
//  Created by Khalid Mahmoud on 04/08/2023.
//

import UIKit

class SegmentControl: UISegmentedControl {
    
    private(set) lazy var radius: CGFloat = 8 //bounds.height / 2
    
    /// Configure selected segment inset, can't be zero or size will error when click segment
    private var segmentInset: CGFloat = 6.0 {
        didSet {
            if segmentInset == 0 {
                segmentInset = 6.0
            }
        }
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        selectedSegmentIndex = 0
        self.setTitleTextAttributes([.font: UIFont.appFont(ofSize: 13, weight: .regular)!], for: .normal)
        self.setTitleTextAttributes([.font: UIFont.appFont(ofSize: 13, weight: .regular)!], for: .highlighted)
        self.setTitleTextAttributes([.font: UIFont.appFont(ofSize: 13, weight: .semibold)!], for: .selected)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //MARK: - Configure Background Radius
        self.layer.cornerRadius = self.radius
        self.layer.masksToBounds = true
        
        //MARK: - Find selectedImageView
        let selectedImageViewIndex = numberOfSegments
        if let selectedImageView = subviews[selectedImageViewIndex] as? UIImageView
        {
            //MARK: - Configure selectedImageView Color
            selectedImageView.backgroundColor = UIColor.white
//            UIColor().colorWithHexString(hexString: "38455D") //.white
            selectedImageView.image = nil
            
            //MARK: - Configure selectedImageView Inset with SegmentControl
            selectedImageView.bounds = selectedImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
            
            //MARK: - Configure selectedImageView cornerRadius
            selectedImageView.layer.masksToBounds = true
            selectedImageView.layer.cornerRadius = self.radius-3
            
            selectedImageView.layer.removeAnimation(forKey: "SelectionBounds")
        }
    }
}
