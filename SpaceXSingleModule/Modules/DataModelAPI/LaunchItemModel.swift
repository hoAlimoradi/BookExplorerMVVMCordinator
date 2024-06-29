//
//  LaunchItemModel.swift
//  DataModelAPI
//
//  Created by ho on 4/8/1403 AP.
//

import Foundation
// Item Models
public struct LaunchItemModel: Hashable {
    public let id: String?
    public let name: String?
    public let dateUTC: Date?
    public let dateUnix: Int?
    public let dateLocal: String?
    public let datePrecision: String?
    public let staticFireDateUTC: String?
    public let staticFireDateUnix: Int?
    public let tbd: Bool?
    public let net: Bool?
    public let window: Int?
    public let rocket: String?
    public let success: Bool?
    public let details: String?
    public let flightNumber: Int?
    public let upcoming: Bool?
    public let failures: [FailureItemModel]?
    public let cores: [CoreItemModel]?
    public let links: LinksItemModel?
}

public struct FailureItemModel: Hashable {
    public let time: Int?
    public let altitude: Int?
    public let reason: String?
}

public struct CoreItemModel: Hashable {
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

public struct LinksItemModel: Hashable {
    public let patch: PatchItemModel?
    public let reddit: RedditItemModel?
    public let flickr: FlickrItemModel?
    public let presskit: String?
    public let webcast: String?
    public let youtubeID: String?
    public let article: String?
    public let wikipedia: String?
}

public struct PatchItemModel: Hashable {
    public let small: String?
    public let large: String?
}

public struct RedditItemModel: Hashable {
    public let campaign: String?
    public let launch: String?
    public let media: String?
    public let recovery: String?
}

public struct FlickrItemModel: Hashable {
    public let small: [String]?
    public let original: [String]?
}
