//
//  ApiBook.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/23/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation

// If your company develops the API then it's relatively safe to have a single representation
// for both the API entities and your core entities. So depending on the complexity of your app this entity might be an overkill
struct ApiBook: InitializableWithData, InitializableWithJson {
	var id: String
	var isbn: String
	var title: String
	var author: String
	var releaseDate: Date?
	var pages: Int
	
	init(data: Data?) throws {
		// Here you can parse the JSON or XML using the build in APIs or your favorite libraries
		guard let data = data,
			let jsonObject = try? JSONSerialization.jsonObject(with: data),
			let json = jsonObject as? [String: Any] else {
			throw NSError.createPraseError()
		}
		
		try self.init(json: json)

	}
	
	init(json: [String : Any]) throws {
		guard let id = json["Id"] as? String,
			let isbn = json["ISBN"] as? String,
			let title = json["Title"] as? String,
			let author = json["Author"] as? String,
			let pages = json["Pages"] as? Int,
			let releaseDate = json["ReleaseDate"] as? Date else {
				throw NSError.createPraseError()
		}
		
		self.id = id
		self.isbn = isbn
		self.title = title
		self.author = author
		self.pages = pages
		self.releaseDate = releaseDate
	}
}

extension ApiBook {
	var book: Book {
		return Book(id: id,
		            isbn: isbn,
		            title: title,
		            author: author,
		            releaseDate: releaseDate,
		            pages: pages)
	}
}
