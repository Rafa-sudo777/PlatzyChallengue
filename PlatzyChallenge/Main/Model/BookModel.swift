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
    let country: Country
    let mediaType, released: String
    let characters: [String]
}

enum AuthorModel: String, Codable {
    case georgeRRMartin = "George R. R. Martin"
}

enum Country: String, Codable {
    case unitedStates = "United States"
    case unitedStatus = "United Status"
}
