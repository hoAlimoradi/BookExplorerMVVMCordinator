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
