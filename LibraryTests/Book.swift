//
//  Book.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/28/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation
@testable import Library

extension Book {
	static func createBooksArray(numberOfElements: Int = 2) -> [Book] {
		var books = [Book]()
		
		for i in 0..<numberOfElements {
			let book = createBook(index: i)
			books.append(book)
		}
		
		return books
	}
	
	static func createBook(index: Int = 0) -> Book {
		return Book(id: "\(index)", isbn: "ISBN \(index)", title: "Title \(index)", author: "Author \(index)", releaseDate: Date(), pages: index)
	}
}
