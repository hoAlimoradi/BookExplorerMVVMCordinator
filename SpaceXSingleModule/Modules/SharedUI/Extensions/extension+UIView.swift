//
//  extension+UIView.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//

import Foundation
import UIKit

/// Extends `UIView` to provide additional functionality for shadow configuration, corner rounding, swipe gestures, and animations.
extension UIView {
    
    // MARK: - Shadow
    
    /// Sets a basic shadow for the view.
    func setShadow() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(rect: bounds.insetBy(dx: 8, dy: 0)).cgPath
    }
    
    /// Sets a shadow at the bottom left corner of the view.
    func setShadowLeftBottom() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        let shadowPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: 0, y: 0))
        shadowPath.addLine(to: CGPoint(x: 0, y: bounds.height))
        shadowPath.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        
        layer.shadowPath = shadowPath.cgPath
    }
    
    /// Sets a custom shadow for the view.
    /// - Parameters:
    ///   - opacity: The opacity of the shadow.
    ///   - radius: The blur radius of the shadow.
    ///   - shadowColor: The color of the shadow.
    ///   - shadowOffset: The offset of the shadow.
    func setShadow(opacity: Float = 1, radius: CGFloat, shadowColor: CGColor, shadowOffset: CGSize) {
        layer.masksToBounds = false
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
    }
    
    /// Rounds specific corners of the view with a given radius.
    /// - Parameters:
    ///   - corners: The corners to round.
    ///   - radius: The radius of the corner rounding.
    ///   - roundedRect: The rectangle in which the corners are rounded.
    func roundCorners(corners: UIRectCorner, radius: CGSize, roundedRect: CGRect) {
        let maskPath = UIBezierPath(
            roundedRect: roundedRect,
            byRoundingCorners: corners,
            cornerRadii: radius
        )
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    /// Rounds specific corners of the view with a given radius and applies a shadow.
    /// - Parameters:
    ///   - corners: The corners to round.
    ///   - radius: The radius of the corner rounding.
    ///   - bgColor: The background color of the view.
    ///   - cornerCurve: The corner curve style.
    ///   - shadowColor: The color of the shadow.
    ///   - shadowOffset: The offset of the shadow.
    ///   - shadowOpacity: The opacity of the shadow.
    ///   - shadowRadius: The radius of the shadow.
    ///   - boundsInset: The inset of the view's bounds.
    func roundCorners(corners: UIRectCorner, radius: CGFloat, bgColor: UIColor = .white, cornerCurve: CALayerCornerCurve = .continuous, shadowColor: UIColor = .clear, shadowOffset: CGSize = .zero, shadowOpacity: Float = 0, shadowRadius: CGFloat = 0, boundsInset: UIEdgeInsets = .zero) {
        let shape = CAShapeLayer()
        shape.name = "shape"
        let path = UIBezierPath(roundedRect: bounds.inset(by: boundsInset), byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        shape.bounds = frame
        shape.position = center
        shape.path = path.cgPath
        shape.fillColor = bgColor.cgColor
        shape.shadowColor = shadowColor.cgColor
        shape.shadowPath = shape.path
        shape.shadowOffset = shadowOffset
        shape.shadowOpacity = shadowOpacity
        shape.shadowRadius = shadowRadius
        guard layer.sublayers?.filter({ $0.name == "shape" }).first == nil else { return }
        layer.cornerCurve = cornerCurve
        layer.insertSublayer(shape, at: 0)
    }
    
    // MARK: - Swipe Gesture
    
    /// Adds swipe gesture recognizers for all four directions to the view.
    /// - Parameter action: The selector to be called when a swipe gesture is detected.
    func addSwipeGestureAllDirection(action: Selector) {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: action)
        swipeLeft.direction = .left
        swipeLeft.numberOfTouchesRequired = 1
        addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: action)
        swipeRight.direction = .right
        swipeRight.numberOfTouchesRequired = 1
        addGestureRecognizer(swipeRight)

        let swipeUp = UISwipeGestureRecognizer(target: self, action: action)
        swipeUp.direction = .up
        swipeUp.numberOfTouchesRequired = 1
        addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: action)
        swipeDown.direction = .down
        swipeDown.numberOfTouchesRequired = 1
        addGestureRecognizer(swipeDown)
    }
    
    // MARK: - Animation
    
    /// Shows the view with a fade-in animation.
    /// - Parameters:
    ///   - duration: The duration of the animation.
    ///   - options: The animation options.
    func showWithAnimation(duration: TimeInterval = 0.3, options: UIView.AnimationOptions = [.curveEaseIn]) {
        guard self.isHidden else { return }
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: options,
            animations: {
                self.isHidden = false
                self.alpha = 1
            })
    }
    
    /// Hides the view with a fade-out animation.
    /// - Parameters:
    ///   - duration: The duration of the animation.
    ///   - options: The animation options.
    func hideWithAnimation(duration: TimeInterval = 0.3, options: UIView.AnimationOptions = [.curveEaseOut]) {
        guard !self.isHidden else { return }
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: options,
            animations: { [weak self] in
                self?.isHidden = true
                self?.alpha = 0
            })
    }
}


extension UIView {
    func setGradientBackground(colors: [UIColor],
                               startPoint: CGPoint = CGPoint(x: 0.5, y: 0),
                               endPoint: CGPoint = CGPoint(x: 0.5, y: 1),
                               isCircular: Bool? = false) {
        let gradientName = "myGradientLayer"

        // Remove old gradient layer if exists
        if let oldLayer = layer.sublayers?.first(where: { $0.name == gradientName }) as? CAGradientLayer {
            oldLayer.removeFromSuperlayer()
        }

        let gradientLayer = CAGradientLayer()
        gradientLayer.name = gradientName
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = (0..<colors.count).map { NSNumber(value: Double($0) / Double(colors.count - 1)) }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint

        // Configure for circular gradient if isCircular is true
        if isCircular == true {
            let center = CGPoint(x: bounds.midX, y: bounds.midY)
            let radius = min(bounds.width, bounds.height) / 2
            gradientLayer.type = .radial
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            gradientLayer.frame = CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius)
        } 
        layer.insertSublayer(gradientLayer, at: 0)
    }

}
