//
//  CircularLoaderView.swift
//  Maintenance
//
//  Created by Ahmed abuelregal on 02/12/2023.
//

import UIKit

class CircularLoaderView: UIView {
    
    //MARK:- Varibles
    private let innerCirclePathLayer = CAShapeLayer()
    
    private var circleRadius: CGFloat {
        return bounds.height / 2
    }
    
    private var lineWidht: CGFloat {
        return bounds.height * 0.09
    }
    
    private let transform_rotation = "transform.rotation"
    private var strokeColor:UIColor = .red
    
    override var frame: CGRect{
        didSet{
            configure()
        }
    }
    
    //MARK:- Init
    init(strokeColor:UIColor = .red) {
        super.init(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        self.strokeColor = strokeColor
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    //MARK:- Methods
    private func configure() {
        configureInnerCirclePathLayer()
        layer.cornerRadius = circleRadius
        layer.masksToBounds = true
        backgroundColor = .clear
    }
    
    private func innerCirclePath() -> UIBezierPath {
        let startAngle = CGFloat(-Double.pi/2)
        let endAngle = startAngle + CGFloat(Double.pi * 2)
        return UIBezierPath(arcCenter: CGPoint(x: circleRadius, y: circleRadius), radius: circleRadius - CGFloat(lineWidht * 3), startAngle: startAngle, endAngle: endAngle, clockwise: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureInnerCirclePathLayer()
    }
    
    private func configureInnerCirclePathLayer () {
        innerCirclePathLayer.removeFromSuperlayer()
        innerCirclePathLayer.frame = bounds
        innerCirclePathLayer.lineWidth = lineWidht
        innerCirclePathLayer.fillColor = UIColor.clear.cgColor
        innerCirclePathLayer.strokeColor = strokeColor.cgColor
        
        innerCirclePathLayer.path = innerCirclePath().cgPath
        innerCirclePathLayer.strokeEnd = 0.5
        innerCirclePathLayer.lineCap = .round
        innerCirclePathLayer.add(rotationAnimation(clockWise: true), forKey: transform_rotation)
        layer.addSublayer(innerCirclePathLayer)
    }
    
    //MARK:- Animation
    private func rotationAnimation(clockWise: Bool = true) -> CAAnimation  {
        let animation = CABasicAnimation(keyPath: transform_rotation)
        animation.fromValue = clockWise ? 0 : Double.pi * 2
        animation.toValue = clockWise ? Double.pi * 2 : 0
        animation.duration = 1
        animation.repeatCount = MAXFLOAT
        return animation
    }
}
