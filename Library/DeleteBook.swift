//
//  DeleteBook.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/23/17.
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

typealias DeleteBookUseCaseCompletionHandler = (_ books: Result<Void>) -> Void

struct DeleteBookUseCaseNotifications {
	// Notification sent when a book is deleted having the book set to the notification object
	static let didDeleteBook = Notification.Name("didDeleteBookNotification")
}

protocol DeleteBookUseCase {
	
	func delete(book: Book, completionHandler: @escaping DeleteBookUseCaseCompletionHandler)
}

class DeleteBookUseCaseImplementation: DeleteBookUseCase {
	
	let booksGateway: BooksGateway
	
	init(booksGateway: BooksGateway) {
		self.booksGateway = booksGateway
	}
	
	// MARK: - DeleteBookUseCase
	
	func delete(book: Book, completionHandler: @escaping (Result<Void>) -> Void) {
		self.booksGateway.delete(book: book) { (result) in
			// Do any additional processing & after that call the completion handler
			// In this case we will broadcast a notification
			switch result {
			case .success():
				NotificationCenter.default.post(name: DeleteBookUseCaseNotifications.didDeleteBook, object: book)
				completionHandler(result)
			case .failure(_):
				completionHandler(result)
			}
		}
	}
	
}
