//
//  BooksPresenterTest.swift
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

import XCTest
@testable import Library

class BooksPresenterTest: XCTestCase {
	// https://www.martinfowler.com/bliki/TestDouble.html
	let diplayBooksUseCaseStub = DisplayBooksUseCaseStub()
	let deleteBookUseCaseSpy = DeleteBookUseCaseSpy()
	let booksViewRouterSpy = BooksViewRouterSpy()
	let booksViewSpy = BooksViewSpy()
	
	var booksPresenter: BooksPresenterImplementation!
	
	// MARK: - Set up
	
    override func setUp() {
        super.setUp()
		booksPresenter = BooksPresenterImplementation(view: booksViewSpy,
		                                displayBooksUseCase: diplayBooksUseCaseStub,
		                                deleteBookUseCase: deleteBookUseCaseSpy,
		                                router: booksViewRouterSpy)
    }
	
	// MARK: - Tests
	
	func test_viewDidLoad_success_refreshBooksView_called() {
		// Given
		let booksToBeReturned = Book.createBooksArray()
		diplayBooksUseCaseStub.resultToBeReturned = .success(booksToBeReturned)
		
		// When
		booksPresenter.viewDidLoad()
		
		// Then
		XCTAssertTrue(booksViewSpy.refreshBooksViewCalled, "refreshBooksView was not called")
	}
	
	func test_viewDidLoad_success_numberOfBooks() {
		// Given
		let expectedNumberOfBooks = 5
		let booksToBeReturned = Book.createBooksArray(numberOfElements: expectedNumberOfBooks)
		diplayBooksUseCaseStub.resultToBeReturned = .success(booksToBeReturned)
		
		// When
		booksPresenter.viewDidLoad()
		
		// Then
		XCTAssertEqual(expectedNumberOfBooks, booksPresenter.numberOfBooks, "Number of books mismatch")
	}
	
	func test_viewDidLoad_failure_displayBooksRetrievalError() {
		// Given
		let expectedErrorTitle = "Error"
		let expectedErrorMessage = "Some error message"
		let errorToBeReturned = NSError.createError(withMessage: expectedErrorMessage)
		diplayBooksUseCaseStub.resultToBeReturned = .failure(errorToBeReturned)
		
		// When
		booksPresenter.viewDidLoad()
		
		// Then
		XCTAssertEqual(expectedErrorTitle, booksViewSpy.displayBooksRetrievalErrorTitle, "Error title doesn't match")
		XCTAssertEqual(expectedErrorMessage, booksViewSpy.displayBooksRetrievalErrorMessage, "Error message doesn't match")
	}
	
	func test_configureCell_has_release_date() {
		// Given
		booksPresenter.books = Book.createBooksArray()
		let expectedDisplayedTitle = "Title 1"
		let expectedDisplayedAuthor = "Author 1"
		let expectedDisplayedReleaseDate = "Long time ago"

		let bookCellViewSpy = BookCellViewSpy()
		
		// When
		booksPresenter.configure(cell: bookCellViewSpy, forRow: 1)
		
		// Then
		XCTAssertEqual(expectedDisplayedTitle, bookCellViewSpy.displayedTitle, "The title we expected was not displayed")
		XCTAssertEqual(expectedDisplayedAuthor, bookCellViewSpy.displayedAuthor, "The author we expected was not displayed")
		XCTAssertEqual(expectedDisplayedReleaseDate, bookCellViewSpy.displayedReleaseDate, "The date we expected was not displayed")
	}
	
	func test_configureCell_release_date_nil() {
		// Given
		let rowToConfigure = 1
		booksPresenter.books = Book.createBooksArray()
		booksPresenter.books[rowToConfigure].releaseDate = nil
		let expectedDisplayedTitle = "Title 1"
		let expectedDisplayedAuthor = "Author 1"
		let expectedDisplayedReleaseDate = "Unknown"
		
		let bookCellViewSpy = BookCellViewSpy()
		
		// When
		booksPresenter.configure(cell: bookCellViewSpy, forRow: rowToConfigure)
		
		// Then
		XCTAssertEqual(expectedDisplayedTitle, bookCellViewSpy.displayedTitle, "The title we expected was not displayed")
		XCTAssertEqual(expectedDisplayedAuthor, bookCellViewSpy.displayedAuthor, "The author we expected was not displayed")
		XCTAssertEqual(expectedDisplayedReleaseDate, bookCellViewSpy.displayedReleaseDate, "The date we expected was not displayed")
	}
	
	func test_didSelect_navigates_to_details_view() {
		// Given
		let books = Book.createBooksArray()
		let rowToSelect = 1
		booksPresenter.books = books
		
		// When
		booksPresenter.didSelect(row: rowToSelect)
		
		// Then
		XCTAssertEqual(books[rowToSelect], booksViewRouterSpy.passedBook, "Expected navigate to details view to be called with book at index 1")
	}
	
	func test_canEdit_always_returns_true() {
		// When
		let anyRow = 0
		let canEdit = booksPresenter.canEdit(row: anyRow)
		
		// Then
		XCTAssertTrue(canEdit, "Can edit should always return true")
	}
	
	func test_titleForDeleteButton_same_for_all_indexes() {
		// Given
		let expectedTitle = "Delete Book"
		let anyRow = 0
		
		// When
		let actualTitle = booksPresenter.titleForDeleteButton(row: anyRow)
		
		// Then
		XCTAssertEqual(expectedTitle, actualTitle, "The title for delete button doesn't match")
	}
	
	func test_deleteButtonPressed_endEditing_called_before_delete_completion_handler() {
		// Given
		let rowToDelete = 1
		let books = Book.createBooksArray()
		booksPresenter.books = books
		deleteBookUseCaseSpy.callCompletionHandlerImmediate = false
		
		// When
		booksPresenter.deleteButtonPressed(row: rowToDelete)
		
		// Then
		XCTAssertTrue(booksViewSpy.endEditingCalled, "End editing should've been called")
		XCTAssertEqual(nil, booksViewSpy.deletedRow, "Delete row on the view shouldn't have been called because we didn't run the completion handler from the use case")
		XCTAssertEqual(nil, booksViewSpy.displayBookDeleteErrorTitle, "Display error on the view shouldn't have been called because we didn't run the completion handler from the use case")
		XCTAssertEqual(nil, booksViewSpy.displayBookDeleteErrorMessage, "Display error on the view shouldn't have been called because we didn't run the completion handler from the use case")
	}
	
	func test_deleteButtonPressed_sucess_view_is_updated() {
		// Given
		let rowToDelete = 1
		let books = Book.createBooksArray()
		let bookToDelete = books[rowToDelete]
		booksPresenter.books = books
		deleteBookUseCaseSpy.resultToBeReturned = .success(())
		
		// When
		booksPresenter.deleteButtonPressed(row: rowToDelete)
		
		// Then
		XCTAssertEqual(bookToDelete, deleteBookUseCaseSpy.bookToDelete, "Book at wrong index was passed to be deleted")
		XCTAssertEqual(rowToDelete, booksViewSpy.deletedRow, "Delete on the view should have been called")
		XCTAssertFalse(booksPresenter.books.contains(bookToDelete), "Book should have been deleted")
	}
	
	func test_deleteButtonPressed_success_book_already_deleted_view_shouldnt_be_updated() {
		// Given
		let rowToDelete = 1
		let books = Book.createBooksArray()
		booksPresenter.books = books
		deleteBookUseCaseSpy.resultToBeReturned = .success(())
		deleteBookUseCaseSpy.callCompletionHandlerImmediate = false
		
		// When
		booksPresenter.deleteButtonPressed(row: rowToDelete)
		booksPresenter.books.remove(at: rowToDelete)
		deleteBookUseCaseSpy.callCompletionHandler()
		
		// Then
		XCTAssertEqual(books[rowToDelete], deleteBookUseCaseSpy.bookToDelete, "Book at wrong index was passed to be deleted")
		XCTAssertEqual(nil, booksViewSpy.deletedRow, "Delete on the view shouldn't have been called")
	}
	
	func test_deleteButtonPressed_failure_view_displays_error() {
		// Given
		let rowToDelete = 1
		let books = Book.createBooksArray()
		booksPresenter.books = books
		let expectedErrorMessage = "Some delete book error message"
		deleteBookUseCaseSpy.resultToBeReturned = .failure(NSError.createError(withMessage: expectedErrorMessage))
		
		// When
		booksPresenter.deleteButtonPressed(row: rowToDelete)
		
		// Then
		XCTAssertEqual(books[rowToDelete], deleteBookUseCaseSpy.bookToDelete, "Book at wrong index was passed to be deleted")
		XCTAssertEqual("Error", booksViewSpy.displayBookDeleteErrorTitle, "Error titlex doesn't match")
		XCTAssertEqual(expectedErrorMessage, booksViewSpy.displayBookDeleteErrorMessage, "Error message doesn't match")
	}
	
	func test_deleteBookUseCase_notification_deletes_book() {
		// Given
		let rowToDelete = 1
		let books = Book.createBooksArray()
		let bookToDelete = books[rowToDelete]
		booksPresenter.books = books
		
		// When
		NotificationCenter.default.post(name: DeleteBookUseCaseNotifications.didDeleteBook, object: bookToDelete)
		
		// Then
		XCTAssertEqual(rowToDelete, booksViewSpy.deletedRow, "Delete on the view should have been called")
		XCTAssertFalse(booksPresenter.books.contains(bookToDelete), "Book should have been deleted")
	}
	
	func test_deleteBookUseCase_notification_book_already_deleted_view_shouldnt_be_updated() {
		// Given
		let rowToDelete = 1
		let books = Book.createBooksArray()
		let bookToDelete = books[rowToDelete]
		
		booksPresenter.books = books
		booksPresenter.books.remove(at: rowToDelete)
		
		// When
		NotificationCenter.default.post(name: DeleteBookUseCaseNotifications.didDeleteBook, object: bookToDelete)
		
		// Then
		XCTAssertEqual(nil, booksViewSpy.deletedRow, "Delete on the view shouldn't have been called")
	}
	
	func test_addButtonPressed_navigates_to_add_book_view() {
		// When
		booksPresenter.addButtonPressed()
		
		// Then
		XCTAssertTrue(booksPresenter === booksViewRouterSpy.passedAddBookPresenterDelegate, "BooksPresenter wasn't passed as delegate to BooksViewRouter")
	}
	
	func test_addBookPresenter_didAdd_book_refreshBooksView_called() {
		// Given
		let addedBook = Book.createBook()
		let addBookViewRouterSpy = AddBookViewRouterSpy()
		let addBookPresenterStub = AddBookPresenterStub(router: addBookViewRouterSpy)
		
		// When
		booksPresenter.addBookPresenter(addBookPresenterStub, didAdd: addedBook)
		
		// Then
		XCTAssertTrue(booksPresenter.books.contains(addedBook), "Book wasn't added in the presenter")
		XCTAssertTrue(addBookViewRouterSpy.didCallDismiss, "Dismiss wasn't called on the AddBookViewRouter")
		XCTAssertTrue(booksViewSpy.refreshBooksViewCalled, "refreshBooksView was not called")
	}
	
	func test_addBookPresenterCancel_dismiss_view() {
		// Given
		let addBookViewRouterSpy = AddBookViewRouterSpy()
		let addBookPresenterStub = AddBookPresenterStub(router: addBookViewRouterSpy)
		
		// When
		booksPresenter.addBookPresenterCancel(presenter: addBookPresenterStub)
		
		// Then
		XCTAssertTrue(addBookViewRouterSpy.didCallDismiss, "Dismiss wasn't called on the AddBookViewRouter")
	}
}


