//
//  LaunchItemModel.swift
//  DataModelAPI
//
//  Created by ho on 4/8/1403 AP.
//

import Foundation 
 
/// Represents a model for a launch item.
public struct LaunchItemModel: Hashable, Identifiable {
    /// The unique identifier of the launch item.
    public let id: String
    
    /// The name of the launch item.
    public let name: String
    
    /// The UTC date of the launch.
    public let dateUTC: Date?
    
    /// The Unix timestamp of the launch date.
    public let dateUnix: Int?
    
    /// The local date string of the launch.
    public let dateLocal: String?
    
    /// The precision of the launch date.
    public let datePrecision: String?
    
    /// The UTC static fire date.
    public let staticFireDateUTC: String?
    
    /// The Unix timestamp of the static fire date.
    public let staticFireDateUnix: Int?
    
    /// Indicates if the launch is to be determined.
    public let tbd: Bool?
    
    /// Indicates if the launch is on a net date.
    public let net: Bool?
    
    /// The launch window duration in seconds.
    public let window: Int?
    
    /// The rocket associated with the launch.
    public let rocket: String
    
    /// Indicates if the launch was successful.
    public let success: Bool?
    
    /// Additional details about the launch.
    public let details: String?
    
    /// The crew members involved in the launch.
    public let crew: [String]?
    
    /// The ships involved in the launch.
    public let ships: [String]?
    
    /// The capsules involved in the launch.
    public let capsules: [String]?
    
    /// The payloads involved in the launch.
    public let payloads: [String]?
    
    /// The launchpad from which the launch took place.
    public let launchpad: String?
    
    /// The flight number of the launch.
    public let flightNumber: Int?
    
    /// Indicates if the launch details are automatically updated.
    public let autoUpdate: Bool?
    
    /// Indicates if the launch is upcoming.
    public let upcoming: Bool?
    
    /// The failures encountered during the launch.
    public let failures: [FailureItemModel]?
    
    /// The cores used in the launch.
    public let cores: [CoreItemModel]?
    
    /// The links related to the launch.
    public let links: LinksItemModel?
}

/// Represents a model for failure details during a launch.
public struct FailureItemModel: Hashable {
    /// The time of the failure.
    public let time: Int?
    
    /// The altitude of the failure.
    public let altitude: Int?
    
    /// The reason for the failure.
    public let reason: String?
}

/// Represents a model for core details during a launch.
public struct CoreItemModel: Hashable {
    /// The core identifier.
    public let core: String?
    
    /// The flight number associated with the core.
    public let flight: Int?
    
    /// Indicates if gridfins were used.
    public let gridfins: Bool?
    
    /// Indicates if legs were used.
    public let legs: Bool?
    
    /// Indicates if the core was reused.
    public let reused: Bool?
    
    /// Indicates if a landing attempt was made.
    public let landingAttempt: Bool?
    
    /// Indicates if the landing was successful.
    public let landingSuccess: Bool?
    
    /// The type of landing.
    public let landingType: String?
    
    /// The landing pad used.
    public let landpad: String?
}

/// Represents a model for links related to a launch.
public struct LinksItemModel: Hashable {
    /// The patch details for the launch.
    public let patch: PatchItemModel?
    
    /// The Reddit details for the launch.
    public let reddit: RedditItemModel?
    
    /// The Flickr details for the launch.
    public let flickr: FlickrItemModel?
    
    /// The press kit URL for the launch.
    public let presskit: String?
    
    /// The webcast URL for the launch.
    public let webcast: String?
    
    /// The YouTube ID for the launch.
    public let youtubeID: String?
    
    /// The article URL for the launch.
    public let article: String?
    
    /// The Wikipedia URL for the launch.
    public let wikipedia: String?
}

/// Represents a model for patch details related to a launch.
public struct PatchItemModel: Hashable {
    /// The URL to the small patch image.
    public let small: String?
    
    /// The URL to the large patch image.
    public let large: String?
}

/// Represents a model for Reddit details related to a launch.
public struct RedditItemModel: Hashable {
    /// The URL to the campaign thread on Reddit.
    public let campaign: String?
    
    /// The URL to the launch thread on Reddit.
    public let launch: String?
    
    /// The URL to the media thread on Reddit.
    public let media: String?
    
    /// The URL to the recovery thread on Reddit.
    public let recovery: String?
}

/// Represents a model for Flickr details related to a launch.
public struct FlickrItemModel: Hashable {
    /// The URLs to small images on Flickr.
    public let small: [String]?
    
    /// The URLs to original images on Flickr.
    public let original: [String]?
}

