//
//  DeleteBook.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/23/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

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
