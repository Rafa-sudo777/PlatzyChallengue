//
//  PlatzyChallengeTests.swift
//  PlatzyChallengeTests
//
//  Created by Rafael Aviles Puebla on 10/07/23.
//

import XCTest
import CoreData
@testable import PlatzyChallenge

@MainActor final class PlatzyChallengeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        clearCoreData()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_fetchBooks_shouldSaveBooksInCoreData() async throws {
        let sutComponents = makeSut()
        sutComponents.retreiveBooksStub.books = listBooks.sorted { $0.name < $1.name }
        let context = PersistenceController.shared.container.viewContext
        do {
            try await sutComponents.sut.fetchBooks()
            
            let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
            let books = try context.fetch(fetchRequest)
            let fetchedBooks = books.sorted { $0.name! < $1.name! }
            XCTAssertEqual(books.count, listBooks.count)
            XCTAssertEqual(fetchedBooks.first?.name, sutComponents.retreiveBooksStub.books.first?.name)
        } catch {
            XCTFail("Failed fetching from Core Data: \(error)")
        }
    }
    
    private func clearCoreData() {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = BookEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)
        } catch {
            print("Error deleting from Core Data: \(error)")
        }
    }
    
    private var listBooks: [BookModel] {
        [BookModel(name: "A Game of Thrones",
                   authors: [.georgeRRMartin],
                   numberOfPages: 694,
                   publisher: "Bantam Books",
                   country: .unitedStates,
                   mediaType: "Hardcover",
                   released: "1996-08-01",
                   characters: ["Eddard Stark", "Daenerys Targaryen", "Jon Snow"]),
         BookModel(name: "A Clash of Kings",
                   authors: [.georgeRRMartin],
                   numberOfPages: 768,
                   publisher: "Bantam Books",
                   country: .unitedStates,
                   mediaType: "Hardcover",
                   released: "1998-11-16",
                   characters: ["Tyrion Lannister", "Arya Stark", "Stannis Baratheon"]),
         BookModel(name: "A Storm of Swords",
                   authors: [.georgeRRMartin],
                   numberOfPages: 973,
                   publisher: "Bantam Books",
                   country: .unitedStates,
                   mediaType: "Hardcover",
                   released: "2000-08-08",
                   characters: ["Bran Stark", "Jaime Lannister", "Catelyn Stark"])]
    }
    
    private func makeSut(file: StaticString = #file,
                                    line: UInt = #line) -> (sut: ListViewModel,
                                                            retreiveBooksStub: RetreiveBooksStub) {
        
        let retreiveBooksStub = RetreiveBooksStub()
        
        let sut = ListViewModel(books: [], retreiveBooks: retreiveBooksStub)
        
        assertMemoryLeak(instance: sut, file: file, line: line)
        
        return (sut, retreiveBooksStub)
    }

}

final class RetreiveBooksStub: RetreiveBooks {
    var books: [BookModel] = []
    func getBooks(url: String) async -> [BookModel] {
        books
    }
}
