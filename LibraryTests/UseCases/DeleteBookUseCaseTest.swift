//
//  DeleteBookUseCaseTest.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/28/17.
//  MIT License
//
//  Copyright (c) 2017 Fortech
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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
		let expectedResultToBeReturned: Result<Void> = Result.success(())
		booksGatewaySpy.deleteBookResultToBeReturned = expectedResultToBeReturned
		
		let deleteBookCompletionHandlerExpectation = expectation(description: "Delete Book Expectation")
		let _ = expectation(forNotification: NSNotification.Name(rawValue: DeleteBookUseCaseNotifications.didDeleteBook.rawValue), object: nil, handler: nil)
		
		// When
		deleteBookUseCase.delete(book: bookToDelete) { (result) in
			// Then
                      XCTAssertTrue(expectedResultToBeReturned == result, "Completion handler didn't return the expected result")
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
                      XCTAssertTrue(expectedResultToBeReturned == result, "Completion handler didn't return the expected result")
			XCTAssertEqual(bookToDelete, self.booksGatewaySpy.deletedBook, "Incorrect book passed to the gateway")
			deleteBookCompletionHandlerExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 1, handler: nil)
	}
}
