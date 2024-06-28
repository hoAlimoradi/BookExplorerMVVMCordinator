//
//  BaseApiResponseModel.swift
//  NetworkAPI
//
//  Created by ho on 4/8/1403 AP.
//

import Foundation
struct BaseApiResponseModel<T: Codable>: Codable {
    let data: T?
}
