//
//  extension+UIView.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//

import Foundation
import UIKit

extension UIView {
   
    // MARK: - Shadow

    func setShadow() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(rect: bounds.insetBy(dx: 8, dy: 0)).cgPath
    }
    func setShadow‌LeftBottom() {
        layer.shadowColor = UIColor.lightGray.cgColor  
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        let shadowPath = UIBezierPath()
        
        // Starting from the top-left corner
        shadowPath.move(to: CGPoint(x: 0, y: 0))
        
        // Adding the line for the left shadow
        shadowPath.addLine(to: CGPoint(x: 0, y: bounds.height))
        
        // Adding the line for the bottom shadow
        shadowPath.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        
        layer.shadowPath = shadowPath.cgPath
    }

    func setShadow(opacity: Float = 1, radius: CGFloat, shadowColor: CGColor, shadowOffset: CGSize) {
        layer.masksToBounds = false
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
    }

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

    func roundCorners(corners: UIRectCorner, radius: CGFloat, bgColor: UIColor = .white, cornerCurve: CALayerCornerCurve = .continuous, shadowColor: UIColor = .clear, shadowOffset: CGSize = CGSize.zero, shadowOpacity: Float = 0, shadowRadius: CGFloat = 0, boundsInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
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
        guard layer.sublayers?.filter({$0.name == "shape"}).first == nil else {
            return
        }
        layer.cornerCurve = cornerCurve
        layer.insertSublayer(shape, at: 0)
    }
    // MARK: - add swipe Gesture
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
    func showWithAnimation(duration: TimeInterval = 0.3,
                           options: UIView.AnimationOptions = [.curveEaseIn]) {
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

    func hideWithAnimation(duration: TimeInterval = 0.3,
                           options: UIView.AnimationOptions = [.curveEaseOut]) {
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
