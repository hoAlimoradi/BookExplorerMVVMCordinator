//
//  LaunchResponseModel.swift
//  NetworkAPI
//
//  Created by ho on 4/8/1403 AP.
//

import Foundation 
// MARK: - LaunchResponseModel
struct LaunchResponseModel: Codable {
    let id: String
    let name: String
    let date: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case date = "date_utc"
    }
}
// MARK: - Mappers
extension LaunchResponseModel {
  func toLaunchItemModel() -> LaunchItemModel {
      return LaunchItemModel(id: self.id,
                             name: self.name,
                             date: self.date?.convertToDateWithTimezone())
  }
}

typealias LaunchListResponseModel = BaseApiResponseModel<[LaunchResponseModel]>

