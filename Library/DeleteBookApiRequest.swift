//
//  DeleteBookApiRequest.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/25/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation

// Dummy implementation. The endpoint doesn't exist.
struct DeleteBookApiRequest: ApiRequest {
	let bookId: String
	
	var urlRequest: URLRequest {
		let url: URL! = URL(string: "https://api.library.fortech.ro/books/\(bookId)")
		var request = URLRequest(url: url)
		
		request.httpMethod = "DELETE"
		
		return request
	}
}
