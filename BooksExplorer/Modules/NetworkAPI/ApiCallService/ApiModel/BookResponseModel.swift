//
//  BookResponseModel.swift
 
import Foundation
// MARK: - OpenLibrary Book Response Model
struct BookResponseModel: Codable {
    let authorName: [String]?
    let key: String?
    let readinglogCount: Int?
    let iaCollection, seed: [String]?
    let wantToReadCount: Int?
    let version: Double?
    let titleSort: String?
    let idStandardEbooks: [String]?
    let ebookAccess, title: String?
    let idAmazon, personFacet: [String]?
    let coverEditionKey, iaCollectionS: String?
    let firstSentence: [String]?
    let type: String?
    let subject: [String]?
    let alreadyReadCount, ratingsAverage: Int?
    let contributor, timeFacet: [String]?
    let lendingIdentifierS: String?
    let publisher: [String]?
    let ebookCountI: Int?
    let authorAlternativeName: [String]?
    let lccSort: String?
    let idOverdrive, publishDate: [String]?
    let printdisabledS: String?
    let authorKey: [String]?
    let coverI: Int?
    let place, subjectKey: [String]?
    let ddcSort: String?
    let idGoodreads, idLibrarything, authorFacet: [String]?
    let lendingEditionS: String?
    let lcc, idBetterWorldBooks, subjectFacet, editionKey: [String]?
    let firstPublishYear: Int?
    let publisherFacet, placeKey: [String]?
    let lastModifiedI: Int?
    let publishYear: [Int]?
    let titleSuggest: String?
    let ddc: [String]?
    let ratingsSortable: Double?
    let currentlyReadingCount, editionCount, numberOfPagesMedian: Int?
    let publishPlace, time, person: [String]?
    let ratingsCount: Int?
    let oclc, personKey, lccn, placeFacet: [String]?
    let ratingsCount1: Int?
    let timeKey, isbn, language, ia: [String]?
    let hasFulltext, publicScanB: Bool?
    let ratingsCount2, ratingsCount3, ratingsCount4, ratingsCount5: Int?
    
    enum CodingKeys: String, CodingKey {
        case authorName = "author_name"
        case key
        case readinglogCount = "readinglog_count"
        case iaCollection = "ia_collection"
        case seed
        case wantToReadCount = "want_to_read_count"
        case version = "_version_"
        case titleSort = "title_sort"
        case idStandardEbooks = "id_standard_ebooks"
        case ebookAccess = "ebook_access"
        case title
        case idAmazon = "id_amazon"
        case personFacet = "person_facet"
        case coverEditionKey = "cover_edition_key"
        case iaCollectionS = "ia_collection_s"
        case firstSentence = "first_sentence"
        case type, subject
        case alreadyReadCount = "already_read_count"
        case ratingsAverage = "ratings_average"
        case contributor
        case timeFacet = "time_facet"
        case lendingIdentifierS = "lending_identifier_s"
        case publisher
        case ebookCountI = "ebook_count_i"
        case authorAlternativeName = "author_alternative_name"
        case lccSort = "lcc_sort"
        case idOverdrive = "id_overdrive"
        case publishDate = "publish_date"
        case printdisabledS = "printdisabled_s"
        case authorKey = "author_key"
        case coverI = "cover_i"
        case place
        case subjectKey = "subject_key"
        case ddcSort = "ddc_sort"
        case idGoodreads = "id_goodreads"
        case idLibrarything = "id_librarything"
        case authorFacet = "author_facet"
        case lendingEditionS = "lending_edition_s"
        case lcc
        case idBetterWorldBooks = "id_better_world_books"
        case subjectFacet = "subject_facet"
        case editionKey = "edition_key"
        case firstPublishYear = "first_publish_year"
        case publisherFacet = "publisher_facet"
        case placeKey = "place_key"
        case lastModifiedI = "last_modified_i"
        case publishYear = "publish_year"
        case titleSuggest = "title_suggest"
        case ddc
        case ratingsSortable = "ratings_sortable"
        case currentlyReadingCount = "currently_reading_count"
        case editionCount = "edition_count"
        case numberOfPagesMedian = "number_of_pages_median"
        case publishPlace = "publish_place"
        case time, person
        case ratingsCount = "ratings_count"
        case oclc
        case personKey = "person_key"
        case lccn
        case placeFacet = "place_facet"
        case ratingsCount1 = "ratings_count_1"
        case timeKey = "time_key"
        case isbn, language, ia
        case hasFulltext = "has_fulltext"
        case publicScanB = "public_scan_b"
        case ratingsCount2 = "ratings_count_2"
        case ratingsCount3 = "ratings_count_3"
        case ratingsCount4 = "ratings_count_4"
        case ratingsCount5 = "ratings_count_5"
    }
}

// Helper function to convert ResponseModel to BookModel
extension BookResponseModel {
    func toBookModel() -> BookItemModel {
        return BookItemModel(id: UUID().uuidString,
                             title: self.title,
                             authors: self.authorName,
                             firstPublishYear: self.firstPublishYear,
                             publisher: self.publisher,
                             subject: self.subject,
                             ratingsAverage: self.ratingsAverage,
                             ratingsCount: self.coverI,
                             isbn: self.isbn)
    }
}
