//
//  DisplayBooksList.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/23/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation

typealias DisplayBooksUseCaseCompletionHandler = (_ books: Result<[Book]>) -> Void

protocol DisplayBooksUseCase {
	func displayBooks(completionHandler: @escaping DisplayBooksUseCaseCompletionHandler)
}

class DisplayBooksListUseCaseImplementation: DisplayBooksUseCase {
	let booksGateway: BooksGateway
	
	init(booksGateway: BooksGateway) {
		self.booksGateway = booksGateway
	}
	
	// MARK: - DisplayBooksUseCase
	
	func displayBooks(completionHandler: @escaping (Result<[Book]>) -> Void) {
		self.booksGateway.fetchBooks { (result) in
			// Do any additional processing & after that call the completion handler
			completionHandler(result)
		}
	}
}
