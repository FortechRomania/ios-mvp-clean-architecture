//
//  LocalPersistenceBooksGateway.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/23/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation
import CoreData

protocol LocalPersistenceBooksGateway: BooksGateway {
	func save(books: [Book])
	
	func add(book: Book)
}

class CoreDataBooksGateway: LocalPersistenceBooksGateway {
	let viewContext: NSManagedObjectContextProtocol
	
	init(viewContext: NSManagedObjectContextProtocol) {
		self.viewContext = viewContext
	}
	
	// MARK: - BooksGateway
	
	func fetchBooks(completionHandler: @escaping (Result<[Book]>) -> Void) {
		if let coreDataBooks = try? viewContext.allEntities(withType: CoreDataBook.self) {
			let books = coreDataBooks.map { $0.book }
			completionHandler(.success(books))
		} else {
			completionHandler(.failure(CoreError(message: "Failed retrieving books the data base")))
		}
	}
	
	func add(parameters: AddBookParameters, completionHandler: @escaping (Result<Book>) -> Void) {
		guard let coreDataBook = viewContext.addEntity(withType: CoreDataBook.self) else {
			completionHandler(.failure(CoreError(message: "Failed adding the book in the data base")))
			return
		}
		
		coreDataBook.populate(with: parameters)
		
		do {
			try viewContext.save()
			completionHandler(.success(coreDataBook.book))
		} catch {
			viewContext.delete(coreDataBook)
			completionHandler(.failure(CoreError(message: "Failed saving the context")))
		}
	}
	
	func delete(book: Book, completionHandler: @escaping (Result<Void>) -> Void) {
		let predicate = NSPredicate(format: "id==%@", book.id)
		
		if let coreDataBooks = try? viewContext.allEntities(withType: CoreDataBook.self, predicate: predicate),
			let coreDataBook = coreDataBooks.first {
			viewContext.delete(coreDataBook)
		} else {
			completionHandler(.failure(CoreError(message: "Failed retrieving books the data base")))
			return
		}
		
		do {
			try viewContext.save()
			completionHandler(.success())
		} catch {
			completionHandler(.failure(CoreError(message: "Failed saving the context")))
		}
		
	}
	
	// MARK: - LocalPersistenceBooksGateway
	
	func save(books: [Book]) {
		// Save books to core data. Depending on your specific need this might need to be turned into some kind of merge mechanism.
	}
	
	func add(book: Book) {
		// Add book. Usually you could call this after the entity was successfully added on the API side or you could use the save method.
	}
}
