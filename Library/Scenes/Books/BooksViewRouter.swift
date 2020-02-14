//
//  BooksViewRouter.swift
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
