//
//  AddBookUseCase.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/24/17.
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
