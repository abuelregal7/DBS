//
//  UIView_Extension.swift
//  Maintenance
//
//  Created by Ahmed abuelregal on 02/12/2023.
//

import UIKit

// MARK: - enums

/// SwifterSwift: Shake directions of a view.
///
/// - horizontal: Shake left and right.
/// - vertical: Shake up and down.
public enum ShakeDirection {
    case horizontal
    case vertical
}

/// SwifterSwift: Angle units.
///
/// - degrees: degrees.
/// - radians: radians.
public enum AngleUnit {
    case degrees
    case radians
}

/// SwifterSwift: Shake animations types.
///
/// - linear: linear animation.
/// - easeIn: easeIn animation
/// - easeOut: easeOut animation.
/// - easeInOut: easeInOut animation.
public enum ShakeAnimationType {
    case linear
    case easeIn
    case easeOut
    case easeInOut
}

// MARK: - Properties
public extension UIView {
    
    /// SwifterSwift: Border color of view; also inspectable from Storyboard.
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            // Fix React-Native conflict issue
            guard String(describing: type(of: color)) != "__NSCFType" else { return }
            layer.borderColor = color.cgColor
        }
    }
    
    /// SwifterSwift: Border width of view; also inspectable from Storyboard.
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
//    /// SwifterSwift: Corner radius of view; also inspectable from Storyboard.
//    @IBInspectable var cornerRadius: CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            if shadowOpacity > 0 {
//                layer.masksToBounds = false
//            } else {
//                layer.masksToBounds = true
//            }
//
//            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
//        }
//    }
    
    @IBInspectable var topCornerRadius: CGFloat  {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    @IBInspectable var bottomCornerRadius: CGFloat  {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    @IBInspectable var leftCornerRadius: CGFloat  {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        }
    }
    
    @IBInspectable var rightCornerRadius: CGFloat  {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
    }

    
    /// SwifterSwift:  automatically set cornerRadius as half of height
    @IBInspectable var isRounded : Bool {
        set {
            let radius = newValue ? self.frame.height/2 : 0
            self.layer.cornerRadius = radius
        }
        get {
            return self.isRounded
        }
    }
    
    
    /// SwifterSwift: First responder.
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        for subView in subviews where subView.isFirstResponder {
            return subView
        }
        return nil
    }
    
    // SwifterSwift: Height of view.
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    
    /// SwifterSwift: Check if view is in RTL format.
    var isRightToLeft: Bool {
        if #available(iOS 10.0, *, tvOS 10.0, *) {
            return effectiveUserInterfaceLayoutDirection == .rightToLeft
        } else {
            return false
        }
    }
    
    /// SwifterSwift: Take screenshot of view (if applicable).
    var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
//    /// SwifterSwift: Shadow color of view; also inspectable from Storyboard.
//    @IBInspectable var shadowColor: UIColor? {
//        get {
//            guard let color = layer.shadowColor else { return nil }
//            return UIColor(cgColor: color)
//        }
//        set {
//            layer.shadowColor = newValue?.cgColor
//        }
//    }
//
//    /// SwifterSwift: Shadow offset of view; also inspectable from Storyboard.
//    @IBInspectable var shadowOffset: CGSize {
//        get {
//            return layer.shadowOffset
//        }
//        set {
//            layer.shadowOffset = newValue
//        }
//    }
//
//    /// SwifterSwift: Shadow opacity of view; also inspectable from Storyboard.
//    @IBInspectable var shadowOpacity: Float {
//        get {
//            return layer.shadowOpacity
//        }
//        set {
//            layer.shadowOpacity = newValue
//        }
//    }
//
//    /// SwifterSwift: Shadow radius of view; also inspectable from Storyboard.
//    @IBInspectable var shadowRadius: CGFloat {
//        get {
//            return layer.shadowRadius
//        }
//        set {
//            layer.shadowRadius = newValue
//        }
//    }
    
    /// SwifterSwift: Size of view.
    var size: CGSize {
        get {
            return frame.size
        }
        set {
            width = newValue.width
            height = newValue.height
        }
    }
    
    /// SwifterSwift: Get view's parent view controller
    var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    /// SwifterSwift: Width of view.
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    
    /// SwifterSwift: x origin of view.
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    
    /// SwifterSwift: y origin of view.
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
}

// MARK: - Methods
public extension UIView {
    
    /// SwifterSwift: Add array of subviews to view.
    ///
    /// - Parameter subviews: array of subviews to add to self.
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach({ self.addSubview($0) })
    }
        
    /// SwifterSwift: Remove all subviews in view.
    func removeSubviews() {
        subviews.forEach({ $0.removeFromSuperview() })
    }
    
    /// SwifterSwift: Remove  subview in view with tag.
    func removeSubviewWithTag(_ tag: Int) {
        subviews.forEach({
            if let viewWithTag = $0.viewWithTag(tag) {
                viewWithTag.removeFromSuperview()
            }
        })
    }
    
    /// A helper function to add multiple subviews.
    func addSubviews(_ subviews: UIView...) {
      subviews.forEach {
        addSubview($0)
      }
    }
    
    /// SwifterSwift: Shake view.
    ///
    /// - Parameters:
    ///   - direction: shake direction (horizontal or vertical), (default is .horizontal)
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - animationType: shake animation type (default is .easeOut).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    func shake(direction: ShakeDirection = .horizontal, duration: TimeInterval = 1,
               animationType: ShakeAnimationType = .easeOut, completion:(() -> Void)? = nil) {
        CATransaction.begin()
        let animation: CAKeyframeAnimation
        switch direction {
        case .horizontal:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        case .vertical:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        }
        switch animationType {
        case .linear:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        case .easeIn:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        case .easeOut:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        case .easeInOut:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        }
        CATransaction.setCompletionBlock(completion)
        animation.duration = duration
        animation.values = [-20.0, 20.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
        CATransaction.commit()
    }

}

extension UIView {
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

@IBDesignable
extension UIView {
    
    func addTopBorder(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorder(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorder(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorder(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    //corner radius for specific corners of a view
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func roundCornersWithMask(_ corners: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
}

extension CACornerMask {
    public static var topLeading: CACornerMask { return .layerMinXMinYCorner }

    public static var topTrailing: CACornerMask { return .layerMaxXMinYCorner }

    public static var bottomLeading: CACornerMask { return .layerMinXMaxYCorner }

    public static var bottomTrailing: CACornerMask { return .layerMaxXMaxYCorner }
}


extension UIView {
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        //clipsToBounds = true
        layer.masksToBounds = true
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        //layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
//
//    @IBInspectable var borderWidth: CGFloat {
//        get {
//            return layer.borderWidth
//        }
//        set {
//            layer.borderWidth = newValue
//        }
//    }
//
//    @IBInspectable var borderColor: UIColor? {
//        get {
//            return UIColor(cgColor: layer.borderColor!)
//        }
//        set {
//            layer.borderColor = newValue?.cgColor
//        }
//    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.masksToBounds = false
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.masksToBounds = false
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.masksToBounds = false
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

struct BorderSides: OptionSet {
    let rawValue: Int
    
    static let top     = BorderSides(rawValue: 1 << 0)
    static let bottom  = BorderSides(rawValue: 1 << 1)
    static let left    = BorderSides(rawValue: 1 << 2)
    static let right   = BorderSides(rawValue: 1 << 3)
    
    static let all: BorderSides = [.top, .bottom, .left, .right]
    static let horizontal: BorderSides = [.left, .right]
    static let vertical: BorderSides = [.top, .bottom]
}

extension UIView {
    func addBorders(sides: BorderSides, color: UIColor, borderWidth: CGFloat) {
        // Remove existing border layers to prevent duplication
        layer.sublayers?.removeAll(where: { $0.name == "BorderLayer" })
        
        // Helper function to create a border
        func createBorderLayer(frame: CGRect) -> CALayer {
            let border = CALayer()
            border.name = "BorderLayer"
            border.frame = frame
            border.backgroundColor = color.cgColor
            return border
        }
        
        // Add top border
        if sides.contains(.top) {
            let topBorder = createBorderLayer(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: borderWidth))
            self.layer.addSublayer(topBorder)
        }
        
        // Add bottom border
        if sides.contains(.bottom) {
            let bottomBorder = createBorderLayer(frame: CGRect(x: 0, y: self.frame.height - borderWidth, width: self.frame.width, height: borderWidth))
            self.layer.addSublayer(bottomBorder)
        }
        
        // Add left border
        if sides.contains(.left) {
            let leftBorder = createBorderLayer(frame: CGRect(x: 0, y: 0, width: borderWidth, height: self.frame.height))
            self.layer.addSublayer(leftBorder)
        }
        
        // Add right border
        if sides.contains(.right) {
            let rightBorder = createBorderLayer(frame: CGRect(x: self.frame.width - borderWidth, y: 0, width: borderWidth, height: self.frame.height))
            self.layer.addSublayer(rightBorder)
        }
    }
}

extension UIView {
    func addGradientBorder(
        colors: [UIColor],
        borderWidth: CGFloat,
        cornerRadius: CGFloat,
        sides: BorderSides
    ) {
        // Remove previous gradient border
        layer.sublayers?.removeAll { $0.name == "GradientBorderLayer" }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "GradientBorderLayer"
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        // Create a shape layer to define the border path
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = borderWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor // Will be masked
        
        // Draw only the requested sides
        let path = CGMutablePath()
        let insetBounds = bounds.insetBy(dx: borderWidth/2, dy: borderWidth/2)
        
        // Top side
        if sides.contains(.top) {
            path.move(to: CGPoint(x: insetBounds.minX + cornerRadius, y: insetBounds.minY))
            path.addLine(to: CGPoint(x: insetBounds.maxX - cornerRadius, y: insetBounds.minY))
            path.addArc(
                center: CGPoint(x: insetBounds.maxX - cornerRadius, y: insetBounds.minY + cornerRadius),
                radius: cornerRadius,
                startAngle: 3 * .pi / 2,
                endAngle: 0,
                clockwise: false
            )
        }
        
        // Right side (only if top was included to connect properly)
        if sides.contains(.right) {
            if !sides.contains(.top) {
                path.move(to: CGPoint(x: insetBounds.maxX, y: insetBounds.minY + cornerRadius))
            }
            path.addLine(to: CGPoint(x: insetBounds.maxX, y: insetBounds.maxY - cornerRadius))
            path.addArc(
                center: CGPoint(x: insetBounds.maxX - cornerRadius, y: insetBounds.maxY - cornerRadius),
                radius: cornerRadius,
                startAngle: 0,
                endAngle: .pi / 2,
                clockwise: false
            )
        }
        
        // Bottom side
        if sides.contains(.bottom) {
            if !sides.contains(.right) {
                path.move(to: CGPoint(x: insetBounds.maxX - cornerRadius, y: insetBounds.maxY))
            }
            path.addLine(to: CGPoint(x: insetBounds.minX + cornerRadius, y: insetBounds.maxY))
            path.addArc(
                center: CGPoint(x: insetBounds.minX + cornerRadius, y: insetBounds.maxY - cornerRadius),
                radius: cornerRadius,
                startAngle: .pi / 2,
                endAngle: .pi,
                clockwise: false
            )
        }
        
        // Left side
        if sides.contains(.left) {
            if !sides.contains(.bottom) {
                path.move(to: CGPoint(x: insetBounds.minX, y: insetBounds.maxY - cornerRadius))
            }
            path.addLine(to: CGPoint(x: insetBounds.minX, y: insetBounds.minY + cornerRadius))
            path.addArc(
                center: CGPoint(x: insetBounds.minX + cornerRadius, y: insetBounds.minY + cornerRadius),
                radius: cornerRadius,
                startAngle: .pi,
                endAngle: 3 * .pi / 2,
                clockwise: false
            )
        }
        
        shapeLayer.path = path
        gradientLayer.mask = shapeLayer
        layer.addSublayer(gradientLayer)
    }
}
