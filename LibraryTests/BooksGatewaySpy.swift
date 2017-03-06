//
//  BooksGatewayStub.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/28/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation
@testable import Library

class BooksGatewaySpy: BooksGateway {
	var fetchBooksResultToBeReturned: Result<[Book]>!
	var addBookResultToBeReturned: Result<Book>!
	var deleteBookResultToBeReturned: Result<Void>!
	
	var deletedBook: Book!
	
	func fetchBooks(completionHandler: @escaping FetchBooksEntityGatewayCompletionHandler) {
		
	}
	
	func add(parameters: AddBookParameters, completionHandler: @escaping AddBookEntityGatewayCompletionHandler) {
		
	}
	
	func delete(book: Book, completionHandler: @escaping DeleteBookEntityGatewayCompletionHandler) {
		deletedBook = book
		completionHandler(deleteBookResultToBeReturned)
	}
}
