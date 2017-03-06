//
//  AddBookUseCase.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/24/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation

typealias AddBookUseCaseCompletionHandler = (_ books: Result<Book>) -> Void

protocol AddBookUseCase {
	func add(parameters: AddBookParameters, completionHandler: @escaping AddBookUseCaseCompletionHandler)
}

// This class is used across all layers - Core, UI and Network
// It's not violating any dependency rules.
// However it might make sense for each layer do define it's own input parameters so it can be used independently of the other layers.
struct AddBookParameters {
	var isbn: String
	var title: String
	var author: String
	var releaseDate: Date?
	var pages: Int
}

class AddBookUseCaseImplementation: AddBookUseCase {
	let booksGateway: BooksGateway
	
	init(booksGateway: BooksGateway) {
		self.booksGateway = booksGateway
	}
	
	// MARK: - DeleteBookUseCase
	
	func add(parameters: AddBookParameters, completionHandler: @escaping (Result<Book>) -> Void) {
		self.booksGateway.add(parameters: parameters) { (result) in
			// Do any additional processing & after that call the completion handler
			completionHandler(result)
		}
	}
	
}
