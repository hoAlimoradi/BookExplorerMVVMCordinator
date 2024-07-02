//
//  DataBaseManagerError.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/11/1403 AP.
//

import Foundation
public enum DataBaseManagerError: Error, Equatable, CustomLocalizedError {
    case backgroundContextSaveError
    case mainContextSaveError
    case failedToOpen
    case notFoundInfomation(String)
    
    public var description: String {
        switch self {
        case .backgroundContextSaveError:
            return "backgroundContextSaveError "
        case .mainContextSaveError:
            return "mainContextSaveError "
        case .failedToOpen:
            return "failedToOpen "
        case .notFoundInfomation(let title):
            return "notFoundInfomation \(title) "
        }
    }
     
    public var customDescription: String {
        return description
    }
}
