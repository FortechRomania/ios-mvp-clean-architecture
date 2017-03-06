//
//  CoreDataBooksGatewayTest.swift
//  Library
//
//  Created by Cosmin Stirbu on 3/1/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import XCTest

@testable import Library

// Discussion:
// Happy path is tested using an in memory core data stack while the error paths are "simulated" using a stub NSManagedObjectContextStub
// Probably you could use NSManagedObjectContextStub for happy path testing as well, however you might not be able to instantiate a NSManagedObject subclass
// without a valid context
class CoreDataBooksGatewayTest: XCTestCase {
	// https://www.martinfowler.com/bliki/TestDouble.html
	var inMemoryCoreDataStack = InMemoryCoreDataStack()
	var managedObjectContextSpy = NSManagedObjectContextSpy()
	
	var inMemoryCoreDataBooksGateway: CoreDataBooksGateway {
		return CoreDataBooksGateway(viewContext: inMemoryCoreDataStack.persistentContainer.viewContext)
	}
	
	var errorPathCoreDataBooksGateway: CoreDataBooksGateway {
		return CoreDataBooksGateway(viewContext: managedObjectContextSpy)
	}
	
	// MARK: - Tests
	
	// Normally add and fetchBooks should be tested independently, but in this case since we're not mocking the
	// Core Data piece (we're using an in-memory persistent store) it's fine to test the one via the other
	func test_add_with_parameters_fetchBooks_withParameters_success() {
		// Given
		let addBookParameters = AddBookParameters.createParameters()
		
		let addBookCompletionHandlerExpectation = expectation(description: "Add book completion handler expectation")
		let fetchBooksCompletionHandlerExpectation = expectation(description: "Fetch books completion handler expectation")
		
		// When
		inMemoryCoreDataBooksGateway.add(parameters: addBookParameters) { (result) in
			// Then
			guard let book = try? result.dematerialize() else {
				XCTFail("Should've saved the book with success")
				return
			}

			Assert(book: book, builtFromParameters: addBookParameters)
			Assert(book: book, wasAddedIn: self.inMemoryCoreDataBooksGateway, expectation: fetchBooksCompletionHandlerExpectation)
				
			addBookCompletionHandlerExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 1, handler: nil)
	}
	
	func test_fetch_failure() {
		// Given
		let expectedResultToBeReturned: Result<[Book]> = .failure(CoreError(message: "Failed retrieving books the data base"))
		managedObjectContextSpy.fetchErrorToThrow = NSError.createError(withMessage: "Some core data error")
		
		let fetchBooksCompletionHandlerExpectation = expectation(description: "Fetch books completion handler expectation")
		
		// When
		errorPathCoreDataBooksGateway.fetchBooks { (result) in
			// Then
			XCTAssertEqual(expectedResultToBeReturned, result, "Failure error wasn't returned")
			fetchBooksCompletionHandlerExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 1, handler: nil)
	}
	
	func test_add_with_parameters_fails_without_reaching_save() {
		// Given
		let expectedResultToBeReturned: Result<Book> = .failure(CoreError(message: "Failed adding the book in the data base"))
		managedObjectContextSpy.addEntityToReturn = nil
		
		let addBookCompletionHandlerExpectation = expectation(description: "Add book completion handler expectation")
		
		// When
		errorPathCoreDataBooksGateway.add(parameters: AddBookParameters.createParameters()) { (result) in
			// Then
			XCTAssertEqual(expectedResultToBeReturned, result, "Failure error wasn't returned")
			addBookCompletionHandlerExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 1, handler: nil)
	}
	
	func test_add_with_parameters_fails_when_saving() {
		// Given
		let expectedResultToBeReturned: Result<Book> = .failure(CoreError(message: "Failed saving the context"))
		let addedCoreDataBook = inMemoryCoreDataStack.fakeEntity(withType: CoreDataBook.self)
		managedObjectContextSpy.addEntityToReturn = addedCoreDataBook
		managedObjectContextSpy.saveErrorToReturn = NSError.createError(withMessage: "Some core data error")
		
		let addBookCompletionHandlerExpectation = expectation(description: "Add book completion handler expectation")
		
		// When
		errorPathCoreDataBooksGateway.add(parameters: AddBookParameters.createParameters()) { (result) in
			// Then
			XCTAssertEqual(expectedResultToBeReturned, result, "Failure error wasn't returned")
			XCTAssertTrue(self.managedObjectContextSpy.deletedObject! === addedCoreDataBook, "The inserted entity should've been deleted")
			addBookCompletionHandlerExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 1, handler: nil)
	}
	
	func test_deleteBook_success() {
		// Given
		let addBookParameters1 = AddBookParameters.createParameters()
		var addedBook1: Book!
		let addBook1CompletionHandlerExpectation = expectation(description: "Add book completion handler expectation")
		inMemoryCoreDataBooksGateway.add(parameters: addBookParameters1) { (result) in
			addedBook1 = try! result.dematerialize()
			addBook1CompletionHandlerExpectation.fulfill()
		}
		waitForExpectations(timeout: 1, handler: nil)
		
		let addBookParameters2 = AddBookParameters.createParameters()
		var addedBook2: Book!
		let addBook2CompletionHandlerExpectation = expectation(description: "Add book completion handler expectation")
		
		inMemoryCoreDataBooksGateway.add(parameters: addBookParameters2) { (result) in
			addedBook2 = try! result.dematerialize()
			addBook2CompletionHandlerExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 1, handler: nil)
		
		let deleteBookCompletionHandlerExpectation = expectation(description: "Delete book completion handler expectation")
		
		// When
		inMemoryCoreDataBooksGateway.delete(book: addedBook1) { (result) in
			XCTAssertEqual(result, Result<Void>.success(), "Expected a success result")
			deleteBookCompletionHandlerExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 1, handler: nil)
		
		// Then
		let fetchBooksCompletionHandlerExpectation = expectation(description: "Fetch books completion handler expectation")
		inMemoryCoreDataBooksGateway.fetchBooks { (result) in
			let books = try! result.dematerialize()
			XCTAssertFalse(books.contains(addedBook1), "The added book should've been deleted")
			XCTAssertTrue(books.contains(addedBook2), "The second book should be contained")
			fetchBooksCompletionHandlerExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 1, handler: nil)
	}
	
	func test_delete_fetch_fails() {
		// Book
		let bookToDelete = Book.createBook()
		let expectedResultToBeReturned: Result<Void> = .failure(CoreError(message: "Failed retrieving books the data base"))
		managedObjectContextSpy.fetchErrorToThrow = NSError.createError(withMessage: "Some core data error")
		
		let deleteBookCompletionHandlerExpectation = expectation(description: "Delete book completion handler expectation")
		
		// When
		errorPathCoreDataBooksGateway.delete(book: bookToDelete) { (result) in
			// Then
			XCTAssertEqual(expectedResultToBeReturned, result, "Failure error wasn't returned")
			deleteBookCompletionHandlerExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 1, handler: nil)
	}
	
	func test_delete_save_fails() {
		// Book
		let bookToDelete = Book.createBook()
		let expectedResultToBeReturned: Result<Void> = .failure(CoreError(message: "Failed saving the context"))
		managedObjectContextSpy.entitiesToReturn = [inMemoryCoreDataStack.fakeEntity(withType: CoreDataBook.self)]
		managedObjectContextSpy.saveErrorToReturn = NSError.createError(withMessage: "Some core data error")
		
		let deleteBookCompletionHandlerExpectation = expectation(description: "Delete book completion handler expectation")
		
		// When
		errorPathCoreDataBooksGateway.delete(book: bookToDelete) { (result) in
			// Then
			XCTAssertEqual(expectedResultToBeReturned, result, "Failure error wasn't returned")
			deleteBookCompletionHandlerExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 1, handler: nil)
	}
}

// MARK: - Helpers

// https://www.bignerdranch.com/blog/creating-a-custom-xctest-assertion/
fileprivate func Assert(book: Book, builtFromParameters parameters: AddBookParameters, file: StaticString = #file, line: UInt = #line) {
	XCTAssertEqual(book.isbn, parameters.isbn, "isbn mismatch", file: file, line: line)
	XCTAssertEqual(book.title, parameters.title, "title mismatch", file: file, line: line)
	XCTAssertEqual(book.author, parameters.author, "author mismatch", file: file, line: line)
	XCTAssertEqual(book.releaseDate?.timeIntervalSince1970, parameters.releaseDate?.timeIntervalSince1970, "releaseDate mismatch", file: file, line: line)
	XCTAssertEqual(book.pages, parameters.pages, "pages mismatch", file: file, line: line)
	XCTAssertTrue(book.id != "", "id should not be empty", file: file, line: line)
}

fileprivate func Assert(book: Book, wasAddedIn coreDataBooksGateway: CoreDataBooksGateway, expectation: XCTestExpectation) {
	coreDataBooksGateway.fetchBooks { (result) in
		guard let books = try? result.dematerialize() else {
			XCTFail("Should've fetched the books with success")
			return
		}
		
		XCTAssertTrue(books.contains(book), "Book is not found in the returned books")
		XCTAssertEqual(books.count, 1, "Books array should contain exactly one book")
		expectation.fulfill()
	}
}
