//
//  extension+UITableView.swift
 

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
