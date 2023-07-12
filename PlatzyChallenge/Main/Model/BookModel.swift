//
//  BookModel.swift
//  PlatzyChallenge
//
//  Created by Rafael Aviles Puebla on 11/07/23.
//

import CoreData

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
        self.country = CountryV(rawValue: coreDataBook.country ?? "") ?? .unitedStates
        // Conversion de NSSet a [AuthorModel]
        if let authorsSet = coreDataBook.authors as? Set<Author> {
            authors = authorsSet.compactMap { AuthorModel(rawValue: $0.name ?? "") }
        } else {
            authors = []
        }
        
        // Conversión de NSSet a [String]
        if let charactersSet = coreDataBook.characters as? Set<Character> {
            characters = charactersSet.compactMap { $0.name }
        } else {
            characters = []
        }
    }
    
    init(name: String,
         authors: [AuthorModel],
         numberOfPages: Int,
         publisher: String,
         country: CountryV,
         mediaType: String,
         released: String,
         characters: [String]) {
        self.name = name
        self.authors = authors
        self.numberOfPages = numberOfPages
        self.publisher = publisher
        self.country = country
        self.mediaType = mediaType
        self.released = released
        self.characters = characters
    }
    
    func toCoreDataBook(context: NSManagedObjectContext) {
        let book = BookEntity(context: context)
        book.name = name
        book.numberOfPages = Int16(numberOfPages)
        book.publisher = publisher
        book.country = country.rawValue
        book.mediaType = mediaType
        book.released = released
        let authorEntities = authors.map { authorModel -> Author in
            let authorEntity = Author(context: context)
            authorEntity.name = authorModel.rawValue
            return authorEntity
        }
        book.authors = NSSet(array: authorEntities)
        let characterEntities = characters.map { characterName -> Character in
            let characterEntity = Character(context: context)
            characterEntity.name = characterName
            return characterEntity
        }
        
        book.characters = NSSet(array: characterEntities)
    }

}

enum AuthorModel: String, Codable {
    case georgeRRMartin = "George R. R. Martin"
}

enum CountryV: String, Codable {
    case unitedStates = "United States"
    case unitedStatus = "United Status"
}
