//
//  CacheBooksGateway.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/23/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation

// Discussion:
// Maybe it makes sense to perform all the operations locally and only after that make the API call
// to sync the local content with the API.
// If that's the case you will only have to change this class and the use case won't be impacted
class CacheBooksGateway: BooksGateway {
	let apiBooksGateway: ApiBooksGateway
	let localPersistenceBooksGateway: LocalPersistenceBooksGateway
	
	init(apiBooksGateway: ApiBooksGateway, localPersistenceBooksGateway: LocalPersistenceBooksGateway) {
		self.apiBooksGateway = apiBooksGateway
		self.localPersistenceBooksGateway = localPersistenceBooksGateway
	}
	
	// MARK: - BooksGateway
	
	func fetchBooks(completionHandler: @escaping (Result<[Book]>) -> Void) {
		apiBooksGateway.fetchBooks { (result) in
			self.handleFetchBooksApiResult(result, completionHandler: completionHandler)
		}
	}
	
	func add(parameters: AddBookParameters, completionHandler: @escaping (Result<Book>) -> Void) {
		apiBooksGateway.add(parameters: parameters) { (result) in
			self.handleAddBookApiResult(result, parameters: parameters, completionHandler: completionHandler)
		}
	}
	
	func delete(book: Book, completionHandler: @escaping (Result<Void>) -> Void) {
		apiBooksGateway.delete(book: book) { (result) in
			self.localPersistenceBooksGateway.delete(book: book, completionHandler: completionHandler)
		}
	}
	
	// MARK: - Private
	
	fileprivate func handleFetchBooksApiResult(_ result: Result<[Book]>, completionHandler: @escaping (Result<[Book]>) -> Void) {
		switch result {
		case let .success(books):
			localPersistenceBooksGateway.save(books: books)
			completionHandler(result)
		case .failure(_):
			localPersistenceBooksGateway.fetchBooks(completionHandler: completionHandler)
		}
	}
	
	fileprivate func handleAddBookApiResult(_ result: Result<Book>, parameters: AddBookParameters, completionHandler: @escaping (Result<Book>) -> Void) {
		switch result {
		case let .success(book):
			self.localPersistenceBooksGateway.add(book: book)
			completionHandler(result)
		case .failure(_):
			self.localPersistenceBooksGateway.add(parameters: parameters, completionHandler: completionHandler)
		}
	}
	
}
