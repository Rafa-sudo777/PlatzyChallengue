//
//  MainViewModel.swift
//  PlatzyChallenge
//
//  Created by Rafael Aviles Puebla on 11/07/23.
//

import CoreData
import Foundation

@MainActor
final class ListViewModel: ObservableObject {
    @Published var books: [BookModel] = []
    private let networkLayer = NetworkLayer()
    
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

        self.books = await self.networkLayer.getBooks(url: "https://www.anapioficeandfire.com/api/books")

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
