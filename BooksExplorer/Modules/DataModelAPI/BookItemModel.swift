//
//  BookItemModel.swift
 

import Foundation

// MARK: - OpenLibrary Book Model (Hashable)
@dynamicCallable
public struct BookItemModel: Hashable {
    let id: String
    let title: String?
    let authors: [String]?
    let firstPublishYear: Int?
    let publisher: [String]?
    let subject: [String]?
    let ratingsAverage: Int?
    let ratingsCount: Int?
    let isbn: [String]?

    // Computed property to export key-value pairs as a concatenated string
    public var exportString: String {
        let keyValueItems = self()
        return keyValueItems.map { "\($0.key): \($0.value)" }.joined(separator: "\n")
    }

    // Implement dynamicallyCall to return a list of key-value pairs
    func dynamicallyCall(withArguments args: [String]) -> [BookKeyValueItemModel] {
        var keyValueItems: [BookKeyValueItemModel] = []

        if let title = title {
            keyValueItems.append(BookKeyValueItemModel(key: "Title", value: title))
        }

        if let authors = authors, !authors.isEmpty {
            let authorsValue = authors.joined(separator: ", ")
            keyValueItems.append(BookKeyValueItemModel(key: "Authors", value: authorsValue))
        }

        if let firstPublishYear = firstPublishYear {
            keyValueItems.append(BookKeyValueItemModel(key: "First Published", value: "\(firstPublishYear)"))
        }

        if let publisher = publisher, !publisher.isEmpty {
            let publisherValue = publisher.joined(separator: ", ")
            keyValueItems.append(BookKeyValueItemModel(key: "Publisher", value: publisherValue))
        }

        if let subject = subject, !subject.isEmpty {
            let subjectValue = subject.joined(separator: ", ")
            keyValueItems.append(BookKeyValueItemModel(key: "Subjects", value: subjectValue))
        }

        if let ratingsAverage = ratingsAverage {
            keyValueItems.append(BookKeyValueItemModel(key: "Average Rating", value: "\(ratingsAverage)"))
        }

        if let ratingsCount = ratingsCount {
            keyValueItems.append(BookKeyValueItemModel(key: "Total Ratings", value: "\(ratingsCount)"))
        }

        if let isbn = isbn, !isbn.isEmpty {
            let isbnValue = isbn.joined(separator: ", ")
            keyValueItems.append(BookKeyValueItemModel(key: "ISBN", value: isbnValue))
        }

        return keyValueItems.isEmpty ? [BookKeyValueItemModel(key: "No details available", value: "")] : keyValueItems
    }
}
 
