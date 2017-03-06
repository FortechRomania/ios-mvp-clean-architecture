//
//  AddBookPresenter.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/24/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation

protocol AddBookView: class {
	func updateAddButtonState(isEnabled enabled: Bool)
	func updateCancelButtonState(isEnabled enabled: Bool)
	func displayAddBookError(title: String, message: String)
}

// In the most simple cases (like this one) the delegate wouldn't be needed
// We added it just to highlight how two presenters would communicate
// Most of the time it's fine for the view controller to dimiss itself
protocol AddBookPresenterDelegate: class {
	func addBookPresenter(_ presenter: AddBookPresenter, didAdd book: Book)
	func addBookPresenterCancel(presenter: AddBookPresenter)
}

protocol AddBookPresenter {
	var router: AddBookViewRouter { get }
	var maximumReleaseDate: Date { get }
	func addButtonPressed(parameters: AddBookParameters)
	func cancelButtonPressed()
}

class AddBookPresenterImplementation: AddBookPresenter {
	fileprivate weak var view: AddBookView?
	fileprivate var addBookUseCase: AddBookUseCase
	fileprivate weak var delegate: AddBookPresenterDelegate?
	private(set) var router: AddBookViewRouter
	
	var maximumReleaseDate: Date {
		return Date()
	}
	
	init(view: AddBookView,
	     addBookUseCase: AddBookUseCase,
	     router: AddBookViewRouter,
	     delegate: AddBookPresenterDelegate?) {
		self.view = view
		self.addBookUseCase = addBookUseCase
		self.router = router
		self.delegate = delegate
	}
	
	func addButtonPressed(parameters: AddBookParameters) {
		updateNavigationItemsState(isEnabled: false)
		addBookUseCase.add(parameters: parameters) { (result) in
			self.updateNavigationItemsState(isEnabled: true)
			switch result {
			case let .success(book):
				self.handleBookAdded(book)
			case let .failure(error):
				self.handleAddBookError(error)
			}
		}
	}
	
	func cancelButtonPressed() {
		delegate?.addBookPresenterCancel(presenter: self)
	}
	
	// MARK: - Private
	
	fileprivate func handleBookAdded(_ book: Book) {
		delegate?.addBookPresenter(self, didAdd: book)
	}
	
	fileprivate func handleAddBookError(_ error: Error) {
		// Here we could check the error code and display a localized error message
		view?.displayAddBookError(title: "Error", message: error.localizedDescription)
	}
	
	fileprivate func updateNavigationItemsState(isEnabled enabled: Bool) {
		view?.updateAddButtonState(isEnabled: enabled)
		view?.updateCancelButtonState(isEnabled: enabled)
	}
}
