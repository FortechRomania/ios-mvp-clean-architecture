//
//  ApiBooksGatewaySpy.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/28/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation
@testable import Library

class ApiBooksGatewaySpy: ApiBooksGateway {
	var fetchBooksResultToBeReturned: Result<[Book]>!
	var addBookResultToBeReturned: Result<Book>!
	var deleteBookResultToBeReturned: Result<Void>!
	
	var addBookParameters: AddBookParameters!
	var deletedBook: Book!
	
	func fetchBooks(completionHandler: @escaping (Result<[Book]>) -> Void) {
		completionHandler(fetchBooksResultToBeReturned)
	}
	
	func add(parameters: AddBookParameters, completionHandler: @escaping (Result<Book>) -> Void) {
		addBookParameters = parameters
		completionHandler(addBookResultToBeReturned)
	}
	
	func delete(book: Book, completionHandler: @escaping (Result<Void>) -> Void) {
		deletedBook = book
		completionHandler(deleteBookResultToBeReturned)
	}
	
}
