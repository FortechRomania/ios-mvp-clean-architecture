//
//  BookDetailsPresenter.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/23/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation

protocol BookDetailsView: class {
	func displayScreenTitle(title: String)
	func display(id: String)
	func display(isbn: String)
	func display(title: String)
	func display(author: String)
	func display(pages: String)
	func display(releaseDate: String)
	func displayDeleteBookError(title: String, message: String)
	func updateCancelButtonState(isEnabled enabled: Bool)
}

protocol BookDetailsPresenter {
	var router: BookDetailsViewRouter { get }
	func viewDidLoad()
	func deleteButtonPressed()
}

class BookDetailsPresenterImplementation: BookDetailsPresenter {
	fileprivate let book: Book
	fileprivate let deleteBookUseCase: DeleteBookUseCase
	let router: BookDetailsViewRouter
	fileprivate weak var view: BookDetailsView?
	
	init(view: BookDetailsView,
	     book: Book,
	     deleteBookUseCase: DeleteBookUseCase,
	     router: BookDetailsViewRouter) {
		self.view = view
		self.book = book
		self.deleteBookUseCase = deleteBookUseCase
		self.router = router
	}
	
	func viewDidLoad() {
		view?.display(id: book.id)
		view?.display(isbn: book.isbn)
		view?.display(title: book.title)
		view?.display(author: book.author)
		view?.display(pages: "\(book.pages) pages")
		view?.display(releaseDate: book.releaseDate?.relativeDescription() ?? "")
	}
	
	func deleteButtonPressed() {
		view?.updateCancelButtonState(isEnabled: false)
		deleteBookUseCase.delete(book: book) { (result) in
			self.view?.updateCancelButtonState(isEnabled: true)
			switch result {
			case .success(_):
				self.handleBookDeleted()
			case let .failure(error):
				self.handleBookDeleteError(error)
			}
		}
	}
	
	// MARK: - Private
	
	fileprivate func handleBookDeleted() {
		// Here we could use a similar approach like on AddBookViewController and call a delegate like we do when adding a book
		// However we want to provide a different example - depending on the complexity of you particular case
		// You can chose one way or the other
		router.dismissView()
	}
	
	fileprivate func handleBookDeleteError(_ error: Error) {
		// Here we could check the error code and display a localized error message
		view?.displayDeleteBookError(title: "Error", message: error.localizedDescription)
	}
}
