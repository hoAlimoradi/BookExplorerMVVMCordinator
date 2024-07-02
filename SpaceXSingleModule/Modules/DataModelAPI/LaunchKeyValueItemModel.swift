//
//  LaunchKeyValueItemModel.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/10/1403 AP.
//

import Foundation
import UIKit

public struct LaunchKeyValueItemModel {
    public let category: String
    public let key: String
    public let value: String
}
public struct LaunchDetailsItemModel {
    public let id: String
    public let name: String
    public let rocket: String
    public let details: String?
    public let imageUrlString: String?
    public let wikiUrlString: String?
}
 
 

 
extension LaunchItemModel {
    func toLaunchDetailsItemModel() -> LaunchDetailsItemModel {
        let launchDetailsItemModel = LaunchDetailsItemModel(id: self.id,
                                                            name: self.name,
                                                            rocket: self.rocket,
                                                            details: self.details,
                                                            imageUrlString: self.links?.patch?.small,
                                                            wikiUrlString: self.links?.wikipedia)
        return launchDetailsItemModel
    }
}
extension LaunchItemModel {
    func toKeyValueItems() -> [LaunchKeyValueItemModel] {
        var items: [LaunchKeyValueItemModel] = []
        let category = "LaunchItemModel"

        items.append(LaunchKeyValueItemModel(category: category, key: "id", value: id))
        items.append(LaunchKeyValueItemModel(category: category, key: "name", value: name ))
        items.append(LaunchKeyValueItemModel(category: category, key: "dateUTC", value: dateUTC?.description ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "dateUnix", value: dateUnix.map { String($0) } ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "dateLocal", value: dateLocal ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "datePrecision", value: datePrecision ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "staticFireDateUTC", value: staticFireDateUTC ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "staticFireDateUnix", value: staticFireDateUnix.map { String($0) } ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "tbd", value: tbd.map { String($0) } ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "net", value: net.map { String($0) } ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "window", value: window.map { String($0) } ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "rocket", value: rocket))
        items.append(LaunchKeyValueItemModel(category: category, key: "success", value: success.map { String($0) } ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "details", value: details ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "flightNumber", value: flightNumber.map { String($0) } ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "upcoming", value: upcoming.map { String($0) } ?? "nil"))
        
        if let failures = failures {
            failures.forEach { items.append(contentsOf: $0.toKeyValueItems()) }
        }

        if let cores = cores {
            cores.forEach { items.append(contentsOf: $0.toKeyValueItems()) }
        }

        if let links = links {
            items.append(contentsOf: links.toKeyValueItems())
        }

        return items
    }
}

extension FailureItemModel {
    func toKeyValueItems() -> [LaunchKeyValueItemModel] {
        var items: [LaunchKeyValueItemModel] = []
        let category = "FailureItemModel"

        items.append(LaunchKeyValueItemModel(category: category, key: "time", value: time.map { String($0) } ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "altitude", value: altitude.map { String($0) } ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "reason", value: reason ?? "nil"))

        return items
    }
}

extension Array where Element == LaunchKeyValueItemModel {
    func toKeyValueString() -> String {
        return self.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
    }
}
extension CoreItemModel {
    func toKeyValueItems() -> [LaunchKeyValueItemModel] {
        var items: [LaunchKeyValueItemModel] = []
        let category = "CoreItemModel"

        items.append(LaunchKeyValueItemModel(category: category, key: "core", value: core ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "flight", value: flight.map { String($0) } ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "gridfins", value: gridfins.map { String($0) } ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "legs", value: legs.map { String($0) } ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "reused", value: reused.map { String($0) } ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "landingAttempt", value: landingAttempt.map { String($0) } ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "landingSuccess", value: landingSuccess.map { String($0) } ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "landingType", value: landingType ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "landpad", value: landpad ?? "nil"))

        return items
    }
}

extension LinksItemModel {
    func toKeyValueItems() -> [LaunchKeyValueItemModel] {
        var items: [LaunchKeyValueItemModel] = []
        let category = "LinksItemModel"

        if let patch = patch {
            items.append(contentsOf: patch.toKeyValueItems())
        }

        if let reddit = reddit {
            items.append(contentsOf: reddit.toKeyValueItems())
        }

        if let flickr = flickr {
            items.append(contentsOf: flickr.toKeyValueItems())
        }

        items.append(LaunchKeyValueItemModel(category: category, key: "presskit", value: presskit ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "webcast", value: webcast ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "youtubeID", value: youtubeID ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "article", value: article ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "wikipedia", value: wikipedia ?? "nil"))

        return items
    }
}

extension PatchItemModel {
    func toKeyValueItems() -> [LaunchKeyValueItemModel] {
        var items: [LaunchKeyValueItemModel] = []
        let category = "PatchItemModel"

        items.append(LaunchKeyValueItemModel(category: category, key: "small", value: small ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "large", value: large ?? "nil"))

        return items
    }
}

extension RedditItemModel {
    func toKeyValueItems() -> [LaunchKeyValueItemModel] {
        var items: [LaunchKeyValueItemModel] = []
        let category = "RedditItemModel"

        items.append(LaunchKeyValueItemModel(category: category, key: "campaign", value: campaign ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "launch", value: launch ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "media", value: media ?? "nil"))
        items.append(LaunchKeyValueItemModel(category: category, key: "recovery", value: recovery ?? "nil"))

        return items
    }
}

extension FlickrItemModel {
    func toKeyValueItems() -> [LaunchKeyValueItemModel] {
        var items: [LaunchKeyValueItemModel] = []
        let category = "FlickrItemModel"

        if let small = small {
            items.append(LaunchKeyValueItemModel(category: category, key: "small", value: small.joined(separator: ", ") ))
        } else {
            items.append(LaunchKeyValueItemModel(category: category, key: "small", value: "nil"))
        }

        if let original = original {
            items.append(LaunchKeyValueItemModel(category: category, key: "original", value: original.joined(separator: ", ") ))
        } else {
            items.append(LaunchKeyValueItemModel(category: category, key: "original", value: "nil"))
        }

        return items
    }
}

