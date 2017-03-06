//
//  DeleteBookUseCaseTest.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/28/17.
//  Copyright © 2017 Fortech. All rights reserved.
//
import XCTest

@testable import Library

class DeleteBookUseCaseTest: XCTestCase {
	// https://www.martinfowler.com/bliki/TestDouble.html
	let booksGatewaySpy = BooksGatewaySpy()
	
	var deleteBookUseCase: DeleteBookUseCaseImplementation!
	
	// MARK: - Set up
	
	override func setUp() {
		super.setUp()
		deleteBookUseCase = DeleteBookUseCaseImplementation(booksGateway: booksGatewaySpy)
	}
	
	// MARK: - Tests
	
	func test_delete_success_sends_notification_calls_completion_handler() {
		// Given
		let bookToDelete = Book.createBook()
		let expectedResultToBeReturned: Result<Void> = Result.success()
		booksGatewaySpy.deleteBookResultToBeReturned = expectedResultToBeReturned
		
		let deleteBookCompletionHandlerExpectation = expectation(description: "Delete Book Expectation")
		let _ = expectation(forNotification: DeleteBookUseCaseNotifications.didDeleteBook.rawValue, object: nil, handler: nil)
		
		// When
		deleteBookUseCase.delete(book: bookToDelete) { (result) in
			// Then
			XCTAssertEqual(expectedResultToBeReturned, result, "Completion handler didn't return the expected result")
			XCTAssertEqual(bookToDelete, self.booksGatewaySpy.deletedBook, "Incorrect book passed to the gateway")
			deleteBookCompletionHandlerExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 1, handler: nil)
	}
	
	func test_delete_failure_calls_completion_handler() {
		// Given
		let bookToDelete = Book.createBook()
		let expectedResultToBeReturned: Result<Void> = Result.failure(NSError.createError(withMessage: "Any message"))
		booksGatewaySpy.deleteBookResultToBeReturned = expectedResultToBeReturned
		
		let deleteBookCompletionHandlerExpectation = expectation(description: "Delete Book Expectation")
		
		// When
		deleteBookUseCase.delete(book: bookToDelete) { (result) in
			// Then
			XCTAssertEqual(expectedResultToBeReturned, result, "Completion handler didn't return the expected result")
			XCTAssertEqual(bookToDelete, self.booksGatewaySpy.deletedBook, "Incorrect book passed to the gateway")
			deleteBookCompletionHandlerExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 1, handler: nil)
	}
}
