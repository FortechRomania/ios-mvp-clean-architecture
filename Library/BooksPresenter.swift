//
//  BooksPresenter.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/23/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation

protocol BooksView: class {
	func refreshBooksView()
	func displayBooksRetrievalError(title: String, message: String)
	func displayBookDeleteError(title: String, message: String)
	func deleteAnimated(row: Int)
	func endEditing()
}

// It would be fine for the cell view to declare a BookCellViewModel property and have it configure itself
// Using this approach makes the view even more passive/dumb - but I can understand if some might consider it an overkill
protocol BookCellView {
	func display(title: String)
	func display(author: String)
	func display(releaseDate: String)
}

protocol BooksPresenter {
	var numberOfBooks: Int { get }
	var router: BooksViewRouter { get }
	func viewDidLoad()
	func configure(cell: BookCellView, forRow row: Int)
	func didSelect(row: Int)
	func canEdit(row: Int) -> Bool
	func titleForDeleteButton(row: Int) -> String
	func deleteButtonPressed(row: Int)
	func addButtonPressed()
}

class BooksPresenterImplementation: BooksPresenter, AddBookPresenterDelegate {
	fileprivate weak var view: BooksView?
	fileprivate let displayBooksUseCase: DisplayBooksUseCase
	fileprivate let deleteBookUseCase: DeleteBookUseCase
	internal let router: BooksViewRouter
	
	// Normally this would be file private as well, we keep it internal so we can inject values for testing purposes
	var books = [Book]()
	
	var numberOfBooks: Int {
		return books.count
	}
	
	init(view: BooksView,
	     displayBooksUseCase: DisplayBooksUseCase,
	     deleteBookUseCase: DeleteBookUseCase,
	     router: BooksViewRouter) {
		self.view = view
		self.displayBooksUseCase = displayBooksUseCase
		self.deleteBookUseCase = deleteBookUseCase
		self.router = router
		
		registerForDeleteBookNotification()
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	// MARK: - BooksPresenter
	
	func viewDidLoad() {
		self.displayBooksUseCase.displayBooks { (result) in
			switch result {
			case let .success(books):
				self.handleBooksReceived(books)
			case let .failure(error):
				self.handleBooksError(error)
			}
		}
	}
	
	func configure(cell: BookCellView, forRow row: Int) {
		let book = books[row]
		
		cell.display(title: book.title)
		cell.display(author: book.author)
		cell.display(releaseDate: book.releaseDate?.relativeDescription() ?? "Unknown")
	}
	
	func didSelect(row: Int) {
		let book = books[row]
		
		router.presentDetailsView(for: book)
	}
	
	func canEdit(row: Int) -> Bool {
		return true
	}
	
	func titleForDeleteButton(row: Int) -> String {
		return "Delete Book"
	}
	
	func deleteButtonPressed(row: Int) {
		view?.endEditing()
		
		let book = books[row]
		deleteBookUseCase.delete(book: book) { (result) in
			switch result {
			case .success():
				self.handleBookDeleted(book: book)
			case let .failure(error):
				self.handleBookDeleteError(error)
			}
		}
	}
	
	func addButtonPressed() {
		router.presentAddBook(addBookPresenterDelegate: self)
	}
	
	// MARK: - AddBookPresenterDelegate
	
	func addBookPresenter(_ presenter: AddBookPresenter, didAdd book: Book) {
		presenter.router.dismiss()
		books.append(book)
		view?.refreshBooksView()
	}
	
	func addBookPresenterCancel(presenter: AddBookPresenter) {
		presenter.router.dismiss()
	}
	
	// MARK: - Private
	
	fileprivate func handleBooksReceived(_ books: [Book]) {
		self.books = books
		view?.refreshBooksView()
	}
	
	fileprivate func handleBooksError(_ error: Error) {
		// Here we could check the error code and display a localized error message
		view?.displayBooksRetrievalError(title: "Error", message: error.localizedDescription)
	}
	
	fileprivate func registerForDeleteBookNotification() {
		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(didReceiveDeleteBookNotification),
		                                       name: DeleteBookUseCaseNotifications.didDeleteBook,
		                                       object: nil)
	}
	
	@objc fileprivate func didReceiveDeleteBookNotification(_ notification: Notification) {
		if let book = notification.object as? Book {
			handleBookDeleted(book: book)
		}
	}
	
	fileprivate func handleBookDeleted(book: Book) {
		// The book might have already be deleted due to the notification response
		if let row = books.index(of: book) {
			books.remove(at: row)
			view?.deleteAnimated(row: row)
		}
	}
	
	fileprivate func handleBookDeleteError(_ error: Error) {
		// Here we could check the error code and display a localized error message
		view?.displayBookDeleteError(title: "Error", message: error.localizedDescription)
	}
}
