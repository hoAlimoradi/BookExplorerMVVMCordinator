//
//  extension+NSObject.swift
 
import Foundation

extension NSObject {
    var customClassName: String {
        return String(describing: type(of: self))
    }
}
