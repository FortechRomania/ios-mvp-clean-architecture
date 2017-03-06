//
//  AddBookParameters.swift
//  Library
//
//  Created by Cosmin Stirbu on 3/1/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation
@testable import Library

extension AddBookParameters {
	static func createParameters() -> AddBookParameters {
		return AddBookParameters(isbn: "isbn", title: "title", author: "author", releaseDate: Date(), pages: 0)
	}
}

extension AddBookParameters: Equatable { }

public func == (lhs: AddBookParameters, rhs: AddBookParameters) -> Bool {
	return lhs.isbn == rhs.isbn && lhs.title == rhs.title && lhs.author == rhs.author && lhs.releaseDate == rhs.releaseDate && lhs.pages == rhs.pages
}
