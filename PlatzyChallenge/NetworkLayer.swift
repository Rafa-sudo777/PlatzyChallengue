//
//  NetworkLayer.swift
//  PlatzyChallenge
//
//  Created by Rafael Aviles Puebla on 11/07/23.
//

import Foundation

final class NetworkLayer: RetreiveBooks {
    var books: [BookModel] = []
    
    func getBooks(url: String) async -> [BookModel] {
        guard let url = URL(string: url) else { return [] }
        let (data, _) = try! await URLSession.shared.data(from: url)
        let booksModel = try! JSONDecoder().decode([BookModel].self, from: data)
        return booksModel
    }
    
    func getCharacters(url: String) async -> CharacterModel {
        guard let url = URL(string: url) else {
            return CharacterModel(name: String(),
                                  gender: String(),
                                  culture: String(),
                                  born: String())
        }
        let (data, _) = try! await URLSession.shared.data(from: url)
        guard let authors = try? JSONDecoder().decode(CharacterModel.self, from: data) else {
            return CharacterModel(name: String(),
                                  gender: String(),
                                  culture: String(),
                                  born: String())
        }
        return authors
    }
}
