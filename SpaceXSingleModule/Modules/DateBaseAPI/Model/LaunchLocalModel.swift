//
//  LaunchLocalModel.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/10/1403 AP.
//
 
import Foundation

 
//MARK: Response Models
struct LaunchDataBaseModel: Codable {
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
     let failures: [FailureDataBaseModel]?
     let details: String?
     let crew: [String]?
     let ships: [String]?
     let capsules: [String]?
     let payloads: [String]?
     let launchpad: String?
     let autoUpdate: Bool?
     let flightNumber: Int?
     let upcoming: Bool?
     let cores: [CoreDataBaseModel]?
     let links: LinksDataBaseModel?
}

 struct FailureDataBaseModel: Codable {
     let time: Int?
     let altitude: Int?
     let reason: String?
}

 struct CoreDataBaseModel: Codable {
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

 struct LinksDataBaseModel: Codable {
     let patch: PatchDataBaseModel?
     let reddit: RedditDataBaseModel?
     let flickr: FlickrDataBaseModel?
     let presskit: String?
     let webcast: String?
     let youtubeID: String?
     let article: String?
     let wikipedia: String?
}

 struct PatchDataBaseModel: Codable {
     let small: String?
     let large: String?
}

 struct RedditDataBaseModel: Codable {
     let campaign: String?
     let launch: String?
     let media: String?
     let recovery: String?
}

 struct FlickrDataBaseModel: Codable {
     let small: [String]?
     let original: [String]?
}

//MARK: mapper LaunchItemModel to LaunchDataBaseModel
 extension LaunchItemModel {
     func toDataBaseModel() -> LaunchDataBaseModel {
         return LaunchDataBaseModel(id: self.id,
                                    name: self.name,
                                    dateUTC: self.dateUTC?.toStringWithTimezone(),
                                    dateUnix: self.dateUnix,
                                    dateLocal: self.dateLocal,
                                    datePrecision: self.datePrecision,
                                    staticFireDateUTC: self.staticFireDateUTC,
                                    staticFireDateUnix: self.staticFireDateUnix,
                                    tbd: self.tbd,
                                    net: self.net,
                                    window: self.window,
                                    rocket: self.rocket,
                                    success: self.success,
                                    failures: self.failures?.toDataBaseModel(),
                                    details: self.details,
                                    crew: self.crew,
                                    ships: self.ships,
                                    capsules: self.capsules,
                                    payloads: self.payloads,
                                    launchpad: self.launchpad ,
                                    autoUpdate: self.autoUpdate,
                                    flightNumber: self.flightNumber,
                                    upcoming: self.upcoming,
                                    cores: self.cores?.toDataBaseModel(),
                                    links: self.links?.toDataBaseModel())
     }
}
 
 extension FailureItemModel {
     func toDataBaseModel() -> FailureDataBaseModel {
         return FailureDataBaseModel(time: self.time,
                                     altitude: self.altitude,
                                     reason: self.reason)
     }
}
extension Array where Element == FailureItemModel {
   func toDataBaseModel() -> [FailureDataBaseModel] {
       return self.map { $0.toDataBaseModel() }
   }
}
 extension CoreItemModel {
     func toDataBaseModel() -> CoreDataBaseModel {
         return CoreDataBaseModel(core: self.core,
                                  flight: self.flight,
                                  gridfins: self.gridfins,
                                  legs: self.legs,
                                  reused: self.reused,
                                  landingAttempt: self.landingAttempt,
                                  landingSuccess: self.landingSuccess,
                                  landingType: self.landingType,
                                  landpad: self.landpad)
     }
}
extension Array where Element == CoreItemModel {
   func toDataBaseModel() -> [CoreDataBaseModel] {
       return self.map { $0.toDataBaseModel() }
   }
}
 extension LinksItemModel {
     func toDataBaseModel() -> LinksDataBaseModel {
         return LinksDataBaseModel(patch: self.patch?.toDataBaseModel(),
                                   reddit: self.reddit?.toDataBaseModel(),
                                   flickr: self.flickr?.toDataBaseModel(),
                                   presskit: self.presskit,
                                   webcast: self.webcast,
                                   youtubeID: self.youtubeID,
                                   article: self.article,
                                   wikipedia: self.wikipedia)
     }
}

 extension PatchItemModel {
     func toDataBaseModel() -> PatchDataBaseModel {
         return PatchDataBaseModel(small: self.small,
                                     large: self.large)
     }
}

 extension RedditItemModel {
     func toDataBaseModel() -> RedditDataBaseModel {
         return RedditDataBaseModel(campaign: self.campaign,
                                    launch: self.launch,
                                    media: self.media,
                                    recovery: self.recovery)
     }
}

 extension FlickrItemModel {
     func toDataBaseModel() -> FlickrDataBaseModel {
         return FlickrDataBaseModel(small: self.small,
                                    original: self.original)
     }
}
 
