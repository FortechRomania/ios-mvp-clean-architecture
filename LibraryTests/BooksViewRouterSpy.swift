//
//  BooksViewRouterSpy.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/27/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation
@testable import Library

class BooksViewRouterSpy: BooksViewRouter {
	var passedBook: Book?
	var passedAddBookPresenterDelegate: AddBookPresenterDelegate?
	
	func presentDetailsView(for book: Book) {
		passedBook = book
	}
	
	func presentAddBook(addBookPresenterDelegate: AddBookPresenterDelegate) {
		passedAddBookPresenterDelegate = addBookPresenterDelegate
	}
}
