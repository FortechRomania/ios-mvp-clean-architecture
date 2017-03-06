//
//  BooksApiRequest.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/25/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation

// Dummy implementation. The endpoint doesn't exist.
struct BooksApiRequest: ApiRequest {
	var urlRequest: URLRequest {
		let url: URL! = URL(string: "https://api.library.fortech.ro/books")
		var request = URLRequest(url: url)
		
		request.setValue("application/vnd.fortech.books-list+json", forHTTPHeaderField: "Accept")
		
		request.httpMethod = "GET"
		
		return request
	}
}
