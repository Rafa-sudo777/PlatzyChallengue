//
//  MainViewModel.swift
//  PlatzyChallenge
//
//  Created by Rafael Aviles Puebla on 11/07/23.
//

import CoreData
import Foundation

protocol RetreiveBooks {
    func getBooks(url: String) async -> [BookModel]
}

@MainActor
final class ListViewModel: ObservableObject {
    @Published var books: [BookModel] = []
    private let retreiveBooks: RetreiveBooks!
    
    init(books: [BookModel], retreiveBooks: RetreiveBooks!) {
        self.books = books
        self.retreiveBooks = retreiveBooks
    }
    
    func fetchBooks() async throws {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()

        do {
            let books = try context.fetch(fetchRequest)
            if !books.isEmpty {
                self.books = books.map { BookModel(coreDataBook: $0) }
                return
            }
        } catch {
            print("Error fetching from Core Data: \(error)")
        }

        books = await self.retreiveBooks.getBooks(url: "https://www.anapioficeandfire.com/api/books")

        await context.perform {
            self.books.forEach { bookModel in
                bookModel.toCoreDataBook(context: context)
            }
            do {
                try context.save()
            } catch let error {
                print("Error saving to Core Data: \(error)")
            }
        }
    }
}
