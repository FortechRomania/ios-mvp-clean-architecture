//
//  CoreDataBook.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/23/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation
import CoreData

// It's best to decouple the application / business logic from your persistence framework
// That's why CoreDataBook - which is a NSManagedObjectModel subclass is converted into a Book entity
extension CoreDataBook {
	var book: Book {
		return Book(id: id ?? "",
		            isbn: isbn ?? "",
		            title: title ?? "",
		            author: author ?? "",
		            releaseDate: releaseDate as? Date,
		            pages: Int(pages))
	}
	
	func populate(with parameters: AddBookParameters) {
		// Normally this id should be used at some point during the sync with the API backend
		id = NSUUID().uuidString
		
		isbn = parameters.isbn
		title = parameters.title
		author = parameters.author
		pages = Int32(parameters.pages)
		releaseDate = parameters.releaseDate != nil ? NSDate(timeIntervalSince1970: parameters.releaseDate!.timeIntervalSince1970) : nil
	}
	
	func populate(with book: Book) {
		id = book.id
		isbn = book.isbn
		title = book.title
		author = book.author
		pages = Int32(book.pages)
		releaseDate = book.releaseDate != nil ? NSDate(timeIntervalSince1970: book.releaseDate!.timeIntervalSince1970) : nil
	}
}
