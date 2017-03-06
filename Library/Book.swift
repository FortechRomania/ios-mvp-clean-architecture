//
//  Book.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/23/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation

struct Book {
	var id: String
	var isbn: String
	var title: String
	var author: String
	var releaseDate: Date?
	var pages: Int
	
	var durationToReadInHours: Double {
		// Let's pretend it takes one hour to read 30 pages.
		// This is what we would usually call business logic - that is logic that is "true" across multiple applications
		// It's true however that usually this would be returned by the API as most of the business logic usually sits on the API side
		return Double(pages) / 30.0
	}
}

extension Book: Equatable { }

func == (lhs: Book, rhs: Book) -> Bool {
	return lhs.id == rhs.id
}
