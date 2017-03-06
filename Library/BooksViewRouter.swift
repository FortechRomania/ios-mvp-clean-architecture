//
//  BooksViewRouter.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/23/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import UIKit

protocol BooksViewRouter: ViewRouter {
	func presentDetailsView(for book: Book)
	func presentAddBook(addBookPresenterDelegate: AddBookPresenterDelegate)
}

class BooksViewRouterImplementation: BooksViewRouter {
	fileprivate weak var booksTableViewController: BooksTableViewController?
	fileprivate weak var addBookPresenterDelegate: AddBookPresenterDelegate?
	fileprivate var book: Book!
	
	init(booksTableViewController: BooksTableViewController) {
		self.booksTableViewController = booksTableViewController
	}
	
	// MARK: - BooksViewRouter
	
	func presentDetailsView(for book: Book) {
		self.book = book
		booksTableViewController?.performSegue(withIdentifier: "BooksSceneToBookDetailsSceneSegue", sender: nil)
	}
	
	func presentAddBook(addBookPresenterDelegate: AddBookPresenterDelegate) {
		self.addBookPresenterDelegate = addBookPresenterDelegate
		booksTableViewController?.performSegue(withIdentifier: "BooksSceneToAddBookSceneSegue", sender: nil)
	}
	
	func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let bookDetailsTableViewController = segue.destination as? BookDetailsTableViewController {
			bookDetailsTableViewController.configurator = BookDetailsConfiguratorImplementation(book: book)
		} else if let navigationController = segue.destination as? UINavigationController,
			let addBookViewController = navigationController.topViewController as? AddBookViewController {
			addBookViewController.configurator = AddBookConfiguratorImplementation(addBookPresenterDelegate: addBookPresenterDelegate)
		}
	}
	
}
