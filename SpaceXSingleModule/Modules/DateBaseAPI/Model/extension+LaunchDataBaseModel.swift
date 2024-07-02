//
//  extension+LaunchDataBaseModel.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/11/1403 AP.
//

import Foundation
// MARK: - Extensions to Convert Models 
extension LaunchDataBaseModel {
    func toLaunchItemModel() -> LaunchItemModel {
        return LaunchItemModel(id: self.id,
                               name: self.name,
                               dateUTC: self.dateUTC?.convertToDateWithTimezone(),
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
                               details: self.details,
                               crew: self.crew,
                               ships: self.ships,
                               capsules: self.capsules,
                               payloads: self.payloads,
                               launchpad: self.launchpad,
                               flightNumber: self.flightNumber,
                               autoUpdate: self.autoUpdate,
                               upcoming: self.upcoming,
                               failures: self.failures?.toItemModel(),
                               cores: self.cores?.toItemModel(),
                               links: self.links?.toItemModel())
    }
}

extension FailureDataBaseModel {
    func toItemModel() -> FailureItemModel {
        return FailureItemModel(time: self.time,
                                altitude: self.altitude,
                                reason: self.reason)
    }
}

extension Array where Element == FailureDataBaseModel {
    func toItemModel() -> [FailureItemModel] {
        return self.map { $0.toItemModel() }
    }
}

extension CoreDataBaseModel {
    func toItemModel() -> CoreItemModel {
        return CoreItemModel(core: self.core,
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

extension Array where Element == CoreDataBaseModel {
    func toItemModel() -> [CoreItemModel] {
        return self.map { $0.toItemModel() }
    }
}

extension LinksDataBaseModel {
    func toItemModel() -> LinksItemModel {
        return LinksItemModel(patch: self.patch?.toItemModel(),
                              reddit: self.reddit?.toItemModel(),
                              flickr: self.flickr?.toItemModel(),
                              presskit: self.presskit,
                              webcast: self.webcast,
                              youtubeID: self.youtubeID,
                              article: self.article,
                              wikipedia: self.wikipedia)
    }
}

extension PatchDataBaseModel {
    func toItemModel() -> PatchItemModel {
        return PatchItemModel(small: self.small,
                              large: self.large)
    }
}

extension RedditDataBaseModel {
    func toItemModel() -> RedditItemModel {
        return RedditItemModel(campaign: self.campaign,
                               launch: self.launch,
                               media: self.media,
                               recovery: self.recovery)
    }
}

extension FlickrDataBaseModel {
    func toItemModel() -> FlickrItemModel {
        return FlickrItemModel(small: self.small,
                               original: self.original)
    }
}
 
