//
//  LaunchResponseModel.swift
//  NetworkAPI
//
//  Created by ho on 4/8/1403 AP.
//

import Foundation 

//MARK: Response Models
struct LaunchResponseModel: Codable {
     let id: String
     let name: String
     let dateUTC: String?
     let dateUnix: Int?
     let dateLocal: String?
     let datePrecision: String?
     let staticFireDateUTC: String?
     let staticFireDateUnix: Int?
     let tbd: Bool?
     let net: Bool?
     let window: Int?
     let rocket: String
     let success: Bool?
     let failures: [FailureResponseModel]?
     let details: String?
     let crew: [String]?
     let ships: [String]?
     let capsules: [String]?
     let payloads: [String]?
     let launchpad: String?
     let autoUpdate: Bool?
     let flightNumber: Int?
     let upcoming: Bool?
     let cores: [CoreResponseModel]?
     let links: LinksResponseModel?
}

 struct FailureResponseModel: Codable {
     let time: Int?
     let altitude: Int?
     let reason: String?
}

 struct CoreResponseModel: Codable {
     let core: String?
     let flight: Int?
     let gridfins: Bool?
     let legs: Bool?
     let reused: Bool?
     let landingAttempt: Bool?
     let landingSuccess: Bool?
     let landingType: String?
     let landpad: String?
}

 struct LinksResponseModel: Codable {
     let patch: PatchResponseModel?
     let reddit: RedditResponseModel?
     let flickr: FlickrResponseModel?
     let presskit: String?
     let webcast: String?
     let youtubeID: String?
     let article: String?
     let wikipedia: String?
}

 struct PatchResponseModel: Codable {
     let small: String?
     let large: String?
}

 struct RedditResponseModel: Codable {
     let campaign: String?
     let launch: String?
     let media: String?
     let recovery: String?
}

 struct FlickrResponseModel: Codable {
     let small: [String]?
     let original: [String]?
}

//MARK: mapper
 extension LaunchItemModel {
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
        self.crew = responseModel.crew
        self.ships = responseModel.ships
        self.capsules = responseModel.capsules
        self.payloads = responseModel.payloads
        self.launchpad = responseModel.launchpad
        self.flightNumber = responseModel.flightNumber
        self.autoUpdate = responseModel.autoUpdate 
        self.upcoming = responseModel.upcoming
        self.failures = responseModel.failures?.map { FailureItemModel(from: $0) }
        self.cores = responseModel.cores?.map { CoreItemModel(from: $0) }
        self.links = responseModel.links.map { LinksItemModel(from: $0) }
    }
}

 extension FailureItemModel {
    init(from responseFailure: FailureResponseModel) {
        self.time = responseFailure.time
        self.altitude = responseFailure.altitude
        self.reason = responseFailure.reason
    }
}

 extension CoreItemModel {
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

 extension LinksItemModel {
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

 extension PatchItemModel {
    init(from responsePatch: PatchResponseModel) {
        self.small = responsePatch.small
        self.large = responsePatch.large
    }
}

 extension RedditItemModel {
    init(from responseReddit: RedditResponseModel) {
        self.campaign = responseReddit.campaign
        self.launch = responseReddit.launch
        self.media = responseReddit.media
        self.recovery = responseReddit.recovery
    }
}

 extension FlickrItemModel {
    init(from responseFlickr: FlickrResponseModel) {
        self.small = responseFlickr.small
        self.original = responseFlickr.original
    }
}

 extension Array where Element == LaunchResponseModel {
    func toLaunchItemModel() -> [LaunchItemModel] {
        return self.map { LaunchItemModel(from: $0) }
    }
}
 typealias LaunchListResponseModel = BaseApiResponseModel<[LaunchResponseModel]>
 
 
