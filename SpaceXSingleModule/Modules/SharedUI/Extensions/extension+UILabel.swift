//
//  extension+UILabel.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//

import Foundation
import UIKit

extension UILabel {
    // MARK: Variable
    private static var tapHandlers = [String: (()->Void)]()

    // MARK: Methods
    private func getAddressAsString() -> String {
        let addr = Unmanaged.passUnretained(self).toOpaque()
        return "\(addr)"
    }
    func setOnTapped(_ handler: @escaping (() -> Void)) {
        UILabel.tapHandlers[getAddressAsString()] = handler
        let gr = UITapGestureRecognizer(target: self, action: #selector(onTapped))
        gr.numberOfTapsRequired = 1
        self.addGestureRecognizer(gr)
        self.isUserInteractionEnabled = true
    }
    @objc private func onTapped() {
        UILabel.tapHandlers[self.getAddressAsString()]?()
    }
}


extension UILabel {

    func retrieveTextHeight () -> CGFloat {
        let attributedText = NSAttributedString(string: self.text!, attributes: [NSAttributedString.Key.font: self.font!])

        let rect = attributedText.boundingRect(with: CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)

        return ceil(rect.size.height)
    }
    
    func autoresize() {
        if let textNSString: NSString = self.text as NSString? {
            let rect = textNSString.boundingRect(with: CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude),
                                                 options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                 attributes: [NSAttributedString.Key.font: self.font!],
                   context: nil)
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: rect.height)
           }
       }

}
