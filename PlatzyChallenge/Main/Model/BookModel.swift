//
//  BookModel.swift
//  PlatzyChallenge
//
//  Created by Rafael Aviles Puebla on 11/07/23.
//

struct BookModel: Codable, Hashable {
    let name: String
    let authors: [AuthorModel]
    let numberOfPages: Int
    let publisher: String
    let country: CountryV
    let mediaType, released: String
    let characters: [String]
    
    init(coreDataBook: BookEntity) {
        self.name = coreDataBook.name ?? ""
        self.numberOfPages = Int(coreDataBook.numberOfPages)
        self.publisher = coreDataBook.publisher ?? ""
        self.mediaType = coreDataBook.mediaType ?? ""
        self.released = coreDataBook.released ?? ""
        
        // Conversion de NSSet a [AuthorModel]
        if let authorsSet = coreDataBook.authors as? Set<Author> {
            authors = authorsSet.compactMap { AuthorModel(rawValue: $0.name ?? "") }
        } else {
            authors = []
        }
        
        // Conversión de NSSet a CountryV
        if let countryVSet = coreDataBook.countrys as? Set<Country>,
           let countryV = countryVSet.first,
           let countryName = countryV.name {
            self.country = CountryV(rawValue: countryName) ?? .unitedStates
        } else {
            country = .unitedStates
        }
        // Conversión de NSSet a [String]
        if let charactersSet = coreDataBook.characters as? Set<Character> {
            characters = charactersSet.compactMap { $0.name }
        } else {
            characters = []
        }
    }
}

enum AuthorModel: String, Codable {
    case georgeRRMartin = "George R. R. Martin"
}

enum CountryV: String, Codable {
    case unitedStates = "United States"
    case unitedStatus = "United Status"
}
