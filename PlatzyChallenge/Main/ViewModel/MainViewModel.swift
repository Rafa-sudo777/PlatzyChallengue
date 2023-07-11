//
//  MainViewModel.swift
//  PlatzyChallenge
//
//  Created by Rafael Aviles Puebla on 11/07/23.
//

import Foundation

final class ListViewModel: ObservableObject {
    @Published var books: [BookModel] = []
    private let networkLayer = NetworkLayer()
    
    init () {
        fetchBooks()
    }
    
    private func fetchBooks() {
        Task {
            books = await networkLayer.getBooks(url: "https://www.anapioficeandfire.com/api/books")
        }
    }
}
