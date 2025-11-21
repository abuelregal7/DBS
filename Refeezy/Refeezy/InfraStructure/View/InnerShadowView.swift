//
//  InnerShadowView.swift
//  Wala
//
//  Created by Ahmed Abo Al-Regal on 09/06/2024.
//

import UIKit

class InnerShadowView: UIView {

    // Define properties for the inner shadow with custom prefixes
    var innerShadowColor: UIColor = .black
    var innerShadowOffset: CGSize = CGSize(width: 0, height: 2)
    var innerShadowBlurRadius: CGFloat = 5.0
    var innerShadowOpacity: Float = 0.5

    override func layoutSubviews() {
        super.layoutSubviews()
        applyInnerShadow()
    }

    private func applyInnerShadow() {
        // Remove existing shadow layers to prevent duplicates
        layer.sublayers?.filter { $0.name == "innerShadowLayer" }.forEach { $0.removeFromSuperlayer() }

        let shadowLayer = CAShapeLayer()
        shadowLayer.name = "innerShadowLayer"
        shadowLayer.frame = bounds

        // Create a path for the shadow
        let path = UIBezierPath(rect: bounds)
        let innerPath = UIBezierPath(rect: bounds.insetBy(dx: -innerShadowBlurRadius, dy: -innerShadowBlurRadius)).reversing()
        path.append(innerPath)

        shadowLayer.shadowPath = path.cgPath
        shadowLayer.masksToBounds = true
        shadowLayer.shadowColor = innerShadowColor.cgColor
        shadowLayer.shadowOffset = innerShadowOffset
        shadowLayer.shadowOpacity = innerShadowOpacity
        shadowLayer.shadowRadius = innerShadowBlurRadius

        // Fill with transparent color to apply the shadow effect
        shadowLayer.fillRule = .evenOdd
        shadowLayer.fillColor = UIColor.white.cgColor
        
        layer.addSublayer(shadowLayer)
    }
}
