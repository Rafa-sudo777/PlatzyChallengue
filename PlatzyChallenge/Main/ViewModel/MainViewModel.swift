//
//  MainViewModel.swift
//  PlatzyChallenge
//
//  Created by Rafael Aviles Puebla on 11/07/23.
//

import Foundation
@MainActor
final class ListViewModel: ObservableObject {
    @Published var books: [BookModel] = []
    private let networkLayer = NetworkLayer()
    
    func fetchBooks() async throws {
        self.books = await self.networkLayer.getBooks(url: "https://www.anapioficeandfire.com/api/books")
    }
}
