//
//  AddBookApiRequest.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/25/17.
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

// Dummy implementation. The endpoint doesn't exist
struct AddBookApiRequest: ApiRequest {
	let addBookParameters: AddBookParameters
	
	var urlRequest: URLRequest {
		let url: URL! = URL(string: "https://api.library.fortech.ro/books")
		var request = URLRequest(url: url)
		
		request.httpMethod = "POST"
		
		request.setValue("application/vnd.fortech.book-creation+json", forHTTPHeaderField: "Content-Type")
		request.setValue("application/vnd.fortech.book+json", forHTTPHeaderField: "Accept")
		
		request.httpBody = addBookParameters.toJsonData()
		
		return request
	}
}

extension AddBookParameters {
	func toJsonData() -> Data {
		var dictionary = [String: Any]()
		
		dictionary["ISBN"] = isbn
		dictionary["Title"] = title
		dictionary["Author"] = author
		dictionary["Pages"] = pages
		
		// Normally this should be formatted to a standard such as ISO8601
		dictionary["ReleaseDate"] = releaseDate?.timeIntervalSinceNow
		
		return dictionary.toJsonData()
	}
}
