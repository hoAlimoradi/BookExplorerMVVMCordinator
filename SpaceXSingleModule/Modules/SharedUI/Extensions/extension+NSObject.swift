//
//  extension+NSObject.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//

import Foundation

extension NSObject {
    var customClassName: String {
        return String(describing: type(of: self))
    }
}
