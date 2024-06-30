//
//  LaunchResponseModel.swift
//  NetworkAPI
//
//  Created by ho on 4/8/1403 AP.
//

import Foundation 

//MARK: Response Models
public struct LaunchResponseModel: Codable {
    public let id: String
    public let name: String
    public let dateUTC: String?
    public let dateUnix: Int?
    public let dateLocal: String?
    public let datePrecision: String?
    public let staticFireDateUTC: String?
    public let staticFireDateUnix: Int?
    public let tbd: Bool?
    public let net: Bool?
    public let window: Int?
    public let rocket: String
    public let success: Bool?
    public let failures: [FailureResponseModel]?
    public let details: String?
    public let crew: [String]?
    public let ships: [String]?
    public let capsules: [String]?
    public let payloads: [String]?
    public let launchpad: String?
    public let autoUpdate: Bool?
    public let flightNumber: Int?
    public let upcoming: Bool?
    public let cores: [CoreResponseModel]?
    public let links: LinksResponseModel?
}

public struct FailureResponseModel: Codable {
    public let time: Int?
    public let altitude: Int?
    public let reason: String?
}

public struct CoreResponseModel: Codable {
    public let core: String?
    public let flight: Int?
    public let gridfins: Bool?
    public let legs: Bool?
    public let reused: Bool?
    public let landingAttempt: Bool?
    public let landingSuccess: Bool?
    public let landingType: String?
    public let landpad: String?
}

public struct LinksResponseModel: Codable {
    public let patch: PatchResponseModel?
    public let reddit: RedditResponseModel?
    public let flickr: FlickrResponseModel?
    public let presskit: String?
    public let webcast: String?
    public let youtubeID: String?
    public let article: String?
    public let wikipedia: String?
}

public struct PatchResponseModel: Codable {
    public let small: String?
    public let large: String?
}

public struct RedditResponseModel: Codable {
    public let campaign: String?
    public let launch: String?
    public let media: String?
    public let recovery: String?
}

public struct FlickrResponseModel: Codable {
    public let small: [String]?
    public let original: [String]?
}

//MARK: mapper
public extension LaunchItemModel {
    init(from responseModel: LaunchResponseModel) {
        self.id = responseModel.id
        self.name = responseModel.name
        self.dateUTC = responseModel.dateUTC?.convertToDateWithTimezone()
        self.dateUnix = responseModel.dateUnix
        self.dateLocal = responseModel.dateLocal
        self.datePrecision = responseModel.datePrecision
        self.staticFireDateUTC = responseModel.staticFireDateUTC
        self.staticFireDateUnix = responseModel.staticFireDateUnix
        self.tbd = responseModel.tbd
        self.net = responseModel.net
        self.window = responseModel.window
        self.rocket = responseModel.rocket
        self.success = responseModel.success
        self.details = responseModel.details
        self.flightNumber = responseModel.flightNumber
        self.upcoming = responseModel.upcoming
        self.failures = responseModel.failures?.map { FailureItemModel(from: $0) }
        self.cores = responseModel.cores?.map { CoreItemModel(from: $0) }
        self.links = responseModel.links.map { LinksItemModel(from: $0) }
    }
}

public extension FailureItemModel {
    init(from responseFailure: FailureResponseModel) {
        self.time = responseFailure.time
        self.altitude = responseFailure.altitude
        self.reason = responseFailure.reason
    }
}

public extension CoreItemModel {
    init(from responseCore: CoreResponseModel) {
        self.core = responseCore.core
        self.flight = responseCore.flight
        self.gridfins = responseCore.gridfins
        self.legs = responseCore.legs
        self.reused = responseCore.reused
        self.landingAttempt = responseCore.landingAttempt
        self.landingSuccess = responseCore.landingSuccess
        self.landingType = responseCore.landingType
        self.landpad = responseCore.landpad
    }
}

public extension LinksItemModel {
    init(from responseLinks: LinksResponseModel) {
        self.patch = responseLinks.patch.map { PatchItemModel(from: $0) }
        self.reddit = responseLinks.reddit.map { RedditItemModel(from: $0) }
        self.flickr = responseLinks.flickr.map { FlickrItemModel(from: $0) }
        self.presskit = responseLinks.presskit
        self.webcast = responseLinks.webcast
        self.youtubeID = responseLinks.youtubeID
        self.article = responseLinks.article
        self.wikipedia = responseLinks.wikipedia
    }
}

public extension PatchItemModel {
    init(from responsePatch: PatchResponseModel) {
        self.small = responsePatch.small
        self.large = responsePatch.large
    }
}

public extension RedditItemModel {
    init(from responseReddit: RedditResponseModel) {
        self.campaign = responseReddit.campaign
        self.launch = responseReddit.launch
        self.media = responseReddit.media
        self.recovery = responseReddit.recovery
    }
}

public extension FlickrItemModel {
    init(from responseFlickr: FlickrResponseModel) {
        self.small = responseFlickr.small
        self.original = responseFlickr.original
    }
}

public extension Array where Element == LaunchResponseModel {
    func toLaunchItemModel() -> [LaunchItemModel] {
        return self.map { LaunchItemModel(from: $0) }
    }
}

//// MARK: - LaunchResponseModel
//struct LaunchResponseModel: Codable {
//    let id: String
//    let name: String
//    let rocket: String
//    let date: String?
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case rocket
//        case date = "date_utc"
//    }
//}
//// MARK: - Mappers
//extension LaunchResponseModel {
//  func toLaunchItemModel() -> LaunchItemModel {
//      return LaunchItemModel(id: self.id,
//                             name: self.name,
//                             rocket: self.rocket,
//                             date: self.date?.convertToDateWithTimezone())
//  }
//}

typealias LaunchListResponseModel = BaseApiResponseModel<[LaunchResponseModel]>
 
 
