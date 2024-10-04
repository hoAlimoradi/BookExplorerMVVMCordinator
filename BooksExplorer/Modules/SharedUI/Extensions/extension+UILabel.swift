//
//  extension+UILabel.swift
 

import Foundation
import UIKit

/// Extends `UILabel` to add additional functionality for handling tap events and text size calculations.
extension UILabel {
    
    private static var tapHandlers = [String: (() -> Void)]()
    
    /// Retrieves the address of the label as a string.
    /// - Returns: A string representation of the label's memory address.
    private func getAddressAsString() -> String {
        let addr = Unmanaged.passUnretained(self).toOpaque()
        return "\(addr)"
    }
    
    /// Sets a closure to be called when the label is tapped.
    /// - Parameter handler: The closure to be executed when the label is tapped.
    func setOnTapped(_ handler: @escaping (() -> Void)) {
        UILabel.tapHandlers[getAddressAsString()] = handler
        let gr = UITapGestureRecognizer(target: self, action: #selector(onTapped))
        gr.numberOfTapsRequired = 1
        self.addGestureRecognizer(gr)
        self.isUserInteractionEnabled = true
    }
    
    /// Handles the tap gesture on the label by executing the associated closure.
    @objc private func onTapped() {
        UILabel.tapHandlers[getAddressAsString()]?()
    }
    
    /// Retrieves the height required to display the label's text.
    /// - Returns: The height needed to display the label's text based on its current width and font.
    func retrieveTextHeight() -> CGFloat {
        guard let text = self.text, let font = self.font else { return 0 }
        
        let attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font])
        
        let rect = attributedText.boundingRect(with: CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(rect.size.height)
    }
    
    /// Adjusts the height of the label to fit its text.
    func autoresize() {
        guard let textNSString = self.text as NSString?, let font = self.font else { return }
        
        let rect = textNSString.boundingRect(with: CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude),
                                             options: .usesLineFragmentOrigin,
                                             attributes: [NSAttributedString.Key.font: font],
                                             context: nil)
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: rect.height)
    }
}

