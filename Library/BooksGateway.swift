//
//  BooksGateway.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/23/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation

typealias FetchBooksEntityGatewayCompletionHandler = (_ books: Result<[Book]>) -> Void
typealias AddBookEntityGatewayCompletionHandler = (_ books: Result<Book>) -> Void
typealias DeleteBookEntityGatewayCompletionHandler = (_ books: Result<Void>) -> Void


protocol BooksGateway {
	func fetchBooks(completionHandler: @escaping FetchBooksEntityGatewayCompletionHandler)
	func add(parameters: AddBookParameters, completionHandler: @escaping AddBookEntityGatewayCompletionHandler)
	func delete(book: Book, completionHandler: @escaping DeleteBookEntityGatewayCompletionHandler)
}
