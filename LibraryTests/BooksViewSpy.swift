//
//  BooksViewSpy.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/27/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation
@testable import Library

class BooksViewSpy: BooksView {
	var refreshBooksViewCalled = false
	var displayBooksRetrievalErrorTitle: String?
	var displayBooksRetrievalErrorMessage: String?
	var displayBookDeleteErrorTitle: String?
	var displayBookDeleteErrorMessage: String?
	var deletedRow: Int?
	var endEditingCalled = false
	
	func refreshBooksView() {
		refreshBooksViewCalled = true
	}
	
	func displayBooksRetrievalError(title: String, message: String) {
		displayBooksRetrievalErrorTitle = title
		displayBooksRetrievalErrorMessage = message
	}
	
	func displayBookDeleteError(title: String, message: String) {
		displayBookDeleteErrorTitle = title
		displayBookDeleteErrorMessage = message
	}
	
	func deleteAnimated(row: Int) {
		deletedRow = row
	}
	
	func endEditing() {
		endEditingCalled = true
	}
}
