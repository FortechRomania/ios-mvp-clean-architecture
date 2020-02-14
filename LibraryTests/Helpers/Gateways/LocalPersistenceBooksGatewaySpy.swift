//
//  LocalPersistenceBooksGateway.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/28/17.
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
@testable import Library

class LocalPersistenceBooksGatewaySpy: LocalPersistenceBooksGateway {
    var fetchBooksResultToBeReturned: Result<[Book]>!
    var addBookResultToBeReturned: Result<Book>!
    var deleteBookResultToBeReturned: Result<Void>!
    
    var addBookParameters: AddBookParameters!
    var deletedBook: Book!
    var booksSaved: [Book]!
    var addedBook: Book!
    
    var fetchBooksCalled = false
    
    func fetchBooks(completionHandler: @escaping (Result<[Book]>) -> Void) {
        fetchBooksCalled = true
        completionHandler(fetchBooksResultToBeReturned)
    }
    
    func add(parameters: AddBookParameters, completionHandler: @escaping (Result<Book>) -> Void) {
        addBookParameters = parameters
        completionHandler(addBookResultToBeReturned)
    }
    
    func delete(book: Book, completionHandler: @escaping (Result<Void>) -> Void) {
        deletedBook = book
        completionHandler(deleteBookResultToBeReturned)
    }
    
    func save(books: [Book]) {
        booksSaved = books
    }
    
    func add(book: Book) {
        addedBook = book
    }
}
