//
//  ApiBook.swift
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

import Foundation

// If your company develops the API then it's relatively safe to have a single representation
// for both the API entities and your core entities. So depending on the complexity of your app this entity might be an overkill
struct ApiBook: Decodable {
      var id: String
      var isbn: String
      var title: String
      var author: String
      var releaseDate: Date?
      var pages: Int
    
      enum CodingKeys: String, CodingKey {
            case id = "Id"
            case isbn = "ISBN"
            case title = "Title"
            case author = "Author"
            case releaseDate = "Pages"
            case pages = "ReleaseDate"
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
