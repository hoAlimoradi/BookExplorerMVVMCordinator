//
//  extension+UITableView.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/10/1403 AP.
//

import Foundation
import UIKit
extension UIScrollView {
    func disableVerticalScrollIndicator() {
        self.showsVerticalScrollIndicator = false
    }
    
    func disableHorizentalScrollIndicator() {
        self.showsHorizontalScrollIndicator = false
    }
}
 
extension UITableView {
    func setDefaultProperties() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        separatorStyle = .none
        disableVerticalScrollIndicator()
        disableHorizentalScrollIndicator()
    }
}
