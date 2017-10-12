//
//  CacheBooksGatewayTest.swift
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

class CacheBooksGatewayTest: XCTestCase {
	// https://www.martinfowler.com/bliki/TestDouble.html
	var apiBooksGatewaySpy = ApiBooksGatewaySpy()
	var localPersistenceBooksGatewaySpy = LocalPersistenceBooksGatewaySpy()
	
	var cacheBooksGateway: CacheBooksGateway!
	
	// MARK: - Set up
	
	override func setUp() {
		super.setUp()
		cacheBooksGateway = CacheBooksGateway(apiBooksGateway: apiBooksGatewaySpy,
		                                      localPersistenceBooksGateway: localPersistenceBooksGatewaySpy)
	}
	
	// MARK: - Tests
	
	func test_fetchBooks_api_success_save_locally() {
		// Given
		let booksToReturn = Book.createBooksArray()
		let expectedResultToBeReturned: Result<[Book]> = .success(booksToReturn)
		
		apiBooksGatewaySpy.fetchBooksResultToBeReturned = expectedResultToBeReturned
		
		let fetchBooksCompletionHandlerExpectation = expectation(description: "Fetch books completion handler expectation")
		
		// When
		cacheBooksGateway.fetchBooks { (result) in
			// Then
			XCTAssertEqual(expectedResultToBeReturned, result, "The expected result wasn't returned")
			XCTAssertEqual(booksToReturn, self.localPersistenceBooksGatewaySpy.booksSaved, "The books weren't saved on the local persistence")
			
			fetchBooksCompletionHandlerExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 1, handler: nil)
	}
	
	func test_fetchBooks_api_failure_fetch_from_local_persistence() {
		// Given
		let booksToReturnFromLocalPersistence = Book.createBooksArray()
		let expectedResultToBeReturnedFromLocalPersistence: Result<[Book]> = .success(booksToReturnFromLocalPersistence)
		let expectedResultFromApi: Result<[Book]> = .failure(NSError.createError(withMessage: "Some error fetching books"))
		
		apiBooksGatewaySpy.fetchBooksResultToBeReturned = expectedResultFromApi
		localPersistenceBooksGatewaySpy.fetchBooksResultToBeReturned = expectedResultToBeReturnedFromLocalPersistence
		
		let fetchBooksCompletionHandlerExpectation = expectation(description: "Fetch books completion handler expectation")
		
		// When
		cacheBooksGateway.fetchBooks { (result) in
			// Then
			XCTAssertEqual(expectedResultToBeReturnedFromLocalPersistence, result, "The expected result wasn't returned")
			XCTAssertTrue(self.localPersistenceBooksGatewaySpy.fetchBooksCalled, "Fetch books wasn't called on the local persistence")
			
			fetchBooksCompletionHandlerExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 1, handler: nil)
	}
	
	func test_add_api_success_add_locally_as_well() {
		// Given
		let bookToAdd = Book.createBook()
		let expectedResultToBeReturned: Result<Book> = .success(bookToAdd)
		let addBookParameters = AddBookParameters.createParameters()
		apiBooksGatewaySpy.addBookResultToBeReturned = expectedResultToBeReturned
		
		let addBookCompletionHandlerExpectation = expectation(description: "Add book completion handler expectation")
		
		// When
		cacheBooksGateway.add(parameters: addBookParameters) { (result) in
			// Then
			XCTAssertEqual(expectedResultToBeReturned, result, "The expected result wasn't returned")
			XCTAssertEqual(addBookParameters, self.apiBooksGatewaySpy.addBookParameters, "Add book parameters passed to API mismatch")
			XCTAssertEqual(bookToAdd, self.localPersistenceBooksGatewaySpy.addedBook, "The added book wasn't passed to the local persistence")
			
			addBookCompletionHandlerExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 1, handler: nil)
	}
	
	func test_add_api_failure_add_locally() {
		// Given
		let bookToAdd = Book.createBook()
		let expectedResultToBeReturnedFromLocalPersistence: Result<Book> = .success(bookToAdd)
		let expectedResultsFromApi: Result<Book>! = .failure(NSError.createError(withMessage: "Some error adding book"))
		let addBookParameters = AddBookParameters.createParameters()
		
		apiBooksGatewaySpy.addBookResultToBeReturned = expectedResultsFromApi
		localPersistenceBooksGatewaySpy.addBookResultToBeReturned = expectedResultToBeReturnedFromLocalPersistence

		let addBookCompletionHandlerExpectation = expectation(description: "Add book completion handler expectation")
		
		// When
		cacheBooksGateway.add(parameters: addBookParameters) { (result) in
			// Then
			XCTAssertEqual(expectedResultToBeReturnedFromLocalPersistence, result, "The expected result wasn't returned")
			XCTAssertEqual(addBookParameters, self.apiBooksGatewaySpy.addBookParameters, "Add book parameters passed to API mismatch")
			XCTAssertEqual(addBookParameters, self.localPersistenceBooksGatewaySpy.addBookParameters, "Add book parameters passed to local persistence mismatch")
			
			addBookCompletionHandlerExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 1, handler: nil)
	}
	
	func test_delete_api_delete_return_response_from_local_repo() {
		// Given
		let bookToDelete = Book.createBook()
		let expectedResultToBeReturnedFromApi: Result<Void> = .failure(NSError.createError(withMessage: "Some error delete book"))
		let expectedResultToBeReturnedFromLocalPersistence: Result<Void> = .success(())
		apiBooksGatewaySpy.deleteBookResultToBeReturned = expectedResultToBeReturnedFromApi
		localPersistenceBooksGatewaySpy.deleteBookResultToBeReturned = expectedResultToBeReturnedFromLocalPersistence
		
		let deleteBookCompletionHandlerExpectation = expectation(description: "Add book completion handler expectation")
		
		// When
		cacheBooksGateway.delete(book: bookToDelete) { (result) in
			XCTAssertEqual(expectedResultToBeReturnedFromLocalPersistence, result, "The expected result wasn't returned")
			XCTAssertEqual(bookToDelete, self.apiBooksGatewaySpy.deletedBook, "Book to delete wasn't passed to the API")
			XCTAssertEqual(bookToDelete, self.localPersistenceBooksGatewaySpy.deletedBook, "Book to delete wasn't passed to the local persistence")
			deleteBookCompletionHandlerExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 1, handler: nil)
	}
}

