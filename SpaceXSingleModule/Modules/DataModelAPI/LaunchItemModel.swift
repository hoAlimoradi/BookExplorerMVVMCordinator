//
//  LaunchItemModel.swift
//  DataModelAPI
//
//  Created by ho on 4/8/1403 AP.
//

import Foundation
public struct LaunchItemModel {
    public let id: String
    public let name: String
    public let date: Date?
    
    public init(id: String, name: String, date: Date?) {
        self.id = id
        self.name = name
        self.date = date
    }
}


