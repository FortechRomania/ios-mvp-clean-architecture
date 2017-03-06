//
//  AddBookApiRequest.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/25/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

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
