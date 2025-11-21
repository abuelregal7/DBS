//
//  StarRatingView.swift
//  EverDeliever
//
//  Created by Ahmed on 3/1/22.
//

import UIKit

protocol StarRatingViewDelegate: AnyObject {
    func ratingDidChange(_ starRatingView: StarRatingView, rating: Float)
}

public enum StarRounding: Int {
    case roundToHalfStar = 0
    case ceilToHalfStar = 1
    case floorToHalfStar = 2
    case roundToFullStar = 3
    case ceilToFullStar = 4
    case floorToFullStar = 5
}

@IBDesignable
class StarRatingView: UIView {
    
    weak var delegate: StarRatingViewDelegate?
    
    @IBInspectable var rating: Float = 3.5 {
        didSet {
            setStarsFor(rating: rating)
            delegate?.ratingDidChange(self, rating: rating)
        }
    }
    
    @IBInspectable var starColor: UIColor = UIColor.systemOrange {
        didSet {
            for starImageView in [hstack?.star1ImageView, hstack?.star2ImageView, hstack?.star3ImageView, hstack?.star4ImageView, hstack?.star5ImageView] {
                starImageView?.tintColor = starColor
            }
        }
    }
    
    var starRounding: StarRounding = .roundToHalfStar {
        didSet {
            setStarsFor(rating: rating)
        }
    }
    
    @IBInspectable var starRoundingRawValue: Int {
        get {
            return self.starRounding.rawValue
        }
        set {
            self.starRounding = StarRounding(rawValue: newValue) ?? .roundToHalfStar
        }
    }
    
    fileprivate var hstack: StarRatingStackView?
    
    fileprivate let fullStarImage: UIImage = UIImage(systemName: "star.fill")!
    fileprivate let halfStarImage: UIImage = UIImage(systemName: "star.lefthalf.fill")!
    fileprivate let emptyStarImage: UIImage = UIImage(systemName: "star")!
    fileprivate let grayStarImage: UIImage = UIImage(systemName: "star.fill")!.withTintColor(UIColor().colorWithHexString(hexString: "DDDDE3"), renderingMode: .alwaysOriginal)
    
    convenience init(frame: CGRect, rating: Float, color: UIColor, starRounding: StarRounding) {
        self.init(frame: frame)
        self.setupView(rating: rating, color: color, starRounding: starRounding)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView(rating: self.rating, color: self.starColor, starRounding: self.starRounding)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView(rating: 3.5, color: UIColor().colorWithHexString(hexString: "F8A02A"), starRounding: .roundToHalfStar)
    }
    
    fileprivate func setupView(rating: Float, color: UIColor, starRounding: StarRounding) {
        let bundle = Bundle(for: StarRatingStackView.self)
        let nib = UINib(nibName: "StarRatingStackView", bundle: bundle)
        let viewFromNib = nib.instantiate(withOwner: self, options: nil)[0] as! StarRatingStackView
        self.addSubview(viewFromNib)
        
        viewFromNib.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[v]|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                metrics: nil,
                views: ["v": viewFromNib]
            )
        )
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[v]|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                metrics: nil, views: ["v": viewFromNib]
            )
        )
        
        self.hstack = viewFromNib
        self.rating = rating
        self.starColor = color
        self.starRounding = starRounding
        
        self.isMultipleTouchEnabled = false
        self.hstack?.isUserInteractionEnabled = false
        
        // Adjust the layout for RTL
        if UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute) == .rightToLeft {
            hstack?.semanticContentAttribute = .forceRightToLeft//.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            for starImageView in [hstack?.star1ImageView, hstack?.star2ImageView, hstack?.star3ImageView, hstack?.star4ImageView, hstack?.star5ImageView] {
                starImageView?.semanticContentAttribute = .forceRightToLeft//.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            }
        }
    }
    
    fileprivate func setStarsFor(rating: Float) {
        let starImageViews = [hstack?.star1ImageView, hstack?.star2ImageView, hstack?.star3ImageView, hstack?.star4ImageView, hstack?.star5ImageView]
        
        if rating == 0.0 {
            for starImageView in starImageViews {
                starImageView?.image = grayStarImage
            }
            return
        }
        
        for i in 1...5 {
            let iFloat = Float(i)
            switch starRounding {
            case .roundToHalfStar:
                starImageViews[i-1]!.image = rating >= iFloat - 0.25 ? fullStarImage :
                                             (rating >= iFloat - 0.75 ? halfStarImage : emptyStarImage)
            case .ceilToHalfStar:
                starImageViews[i-1]!.image = rating > iFloat - 0.5 ? fullStarImage :
                                             (rating > iFloat - 1 ? halfStarImage : emptyStarImage)
            case .floorToHalfStar:
                starImageViews[i-1]!.image = rating >= iFloat ? fullStarImage :
                                             (rating >= iFloat - 0.5 ? halfStarImage : emptyStarImage)
            case .roundToFullStar:
                starImageViews[i-1]!.image = rating >= iFloat - 0.5 ? fullStarImage : emptyStarImage
            case .ceilToFullStar:
                starImageViews[i-1]!.image = rating > iFloat - 1 ? fullStarImage : emptyStarImage
            case .floorToFullStar:
                starImageViews[i-1]!.image = rating >= iFloat ? fullStarImage : emptyStarImage
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touched(touch: touch, moveTouch: false)
        if rating > 5 {
            rating = 5
        } else if rating < 0 {
            rating = 0
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touched(touch: touch, moveTouch: true)
        if rating > 5 {
            rating = 5
        } else if rating < 0 {
            rating = 0
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touched(touch: touch, moveTouch: false)
        if rating > 5 {
            rating = 5
        } else if rating < 0 {
            rating = 0
        }
    }
    
    var lastTouch: Date?
    fileprivate func touched(touch: UITouch, moveTouch: Bool) {
        guard !moveTouch || lastTouch == nil || lastTouch!.timeIntervalSince(Date()) < -0.1 else { return }
        guard let hs = self.hstack else { return }
        
        let touchX = touch.location(in: hs).x
        let touchWidth = hs.frame.width
        
        let isRTL = UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute) == .rightToLeft
        let ratingFromTouch = isRTL ? 5 * (touchWidth - touchX) / touchWidth : 5 * touchX / touchWidth
        
        var roundedRatingFromTouch: Float!
        switch starRounding {
        case .roundToHalfStar:
            roundedRatingFromTouch = Float(round(2 * ratingFromTouch) / 2)
        case .ceilToHalfStar:
            roundedRatingFromTouch = Float(ceil(2 * ratingFromTouch) / 2)
        case .floorToHalfStar:
            roundedRatingFromTouch = Float(floor(2 * ratingFromTouch) / 2)
        case .roundToFullStar:
            roundedRatingFromTouch = Float(round(ratingFromTouch))
        case .ceilToFullStar:
            roundedRatingFromTouch = Float(ceil(ratingFromTouch))
        case .floorToFullStar:
            roundedRatingFromTouch = Float(floor(ratingFromTouch))
        }
        
        self.rating = roundedRatingFromTouch
        lastTouch = Date()
    }
}
