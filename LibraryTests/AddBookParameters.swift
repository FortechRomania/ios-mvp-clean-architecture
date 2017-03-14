//
//  AddBookParameters.swift
//  Library
//
//  Created by Cosmin Stirbu on 3/1/17.
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

extension AddBookParameters {
	static func createParameters() -> AddBookParameters {
		return AddBookParameters(isbn: "isbn", title: "title", author: "author", releaseDate: Date(), pages: 0)
	}
}

extension AddBookParameters: Equatable { }

public func == (lhs: AddBookParameters, rhs: AddBookParameters) -> Bool {
	return lhs.isbn == rhs.isbn && lhs.title == rhs.title && lhs.author == rhs.author && lhs.releaseDate == rhs.releaseDate && lhs.pages == rhs.pages
}
