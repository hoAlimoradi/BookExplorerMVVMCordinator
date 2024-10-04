//
//  LaunchLocalModel.swift
 
import Foundation

 
// MARK: -  BookDataBaseModel
struct BookDataBaseModel: Codable {
    let id: String
    let title: String?
    let authors: [String]?
    let firstPublishYear: Int?
    let publisher: [String]?
    let subject: [String]?
    let ratingsAverage: Int?
    let ratingsCount: Int?
    let isbn: [String]?
}

// MARK: - Extension to map from BookItemModel to BookDataBaseModel
extension BookItemModel {
    func toBookDataBaseModel() -> BookDataBaseModel {
        return BookDataBaseModel(
            id: self.id,
            title: self.title,
            authors: self.authors,
            firstPublishYear: self.firstPublishYear,
            publisher: self.publisher,
            subject: self.subject,
            ratingsAverage: self.ratingsAverage,
            ratingsCount: self.ratingsCount,
            isbn: self.isbn
        )
    }
}

// MARK: - Extension to map from BookDataBaseModel to BookItemModel
extension BookDataBaseModel {
    func toBookItemModel() -> BookItemModel {
        return BookItemModel(
            id: self.id,
            title: self.title,
            authors: self.authors,
            firstPublishYear: self.firstPublishYear,
            publisher: self.publisher,
            subject: self.subject,
            ratingsAverage: self.ratingsAverage,
            ratingsCount: self.ratingsCount,
            isbn: self.isbn
        )
    }
}

// MARK: - Mapper Extension for Array of BookItemModel to Array of BookDataBaseModel
extension Array where Element == BookItemModel {
   func toDataBaseModel() -> [BookDataBaseModel] {
       return self.map { $0.toBookDataBaseModel() }
   }
}

 
