//
//  CurvedTabBar.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/12/1403 AP.
//

import Foundation
import UIKit

class CurvedTabBar: CustomTabBar {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        roundCorners(corners: [.topLeft, .topRight],
                     radius: 20,
                     bgColor: ThemeManager.shared.getCurrentThemeColors().white2,
                     cornerCurve: .continuous,
                     shadowColor: ThemeManager.shared.getCurrentThemeColors().grey1,
                     shadowOffset: CGSize(width: 0, height: 1),
                     shadowOpacity: 0.0, shadowRadius: 0, boundsInset: UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0))
    }
}
