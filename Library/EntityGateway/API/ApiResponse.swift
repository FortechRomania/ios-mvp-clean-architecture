//
//  ApiResponse.swift
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

// Can be thrown when we can't even reach the API
struct NetworkRequestError: Error {
	let error: Error?
	
	var localizedDescription: String {
		return error?.localizedDescription ?? "Network request error - no other information"
	}
}

// Can be thrown when we reach the API but the it returns a 4xx or a 5xx
struct ApiError: Error {
	let data: Data?
	let httpUrlResponse: HTTPURLResponse
}

// Can be thrown by InitializableWithData.init(data: Data?) implementations when parsing the data
struct ApiParseError: Error {
	static let code = 999
	
	let error: Error
	let httpUrlResponse: HTTPURLResponse
	let data: Data?
	
	var localizedDescription: String {
		return error.localizedDescription
	}
}

// This wraps a successful API response and it includes the generic data as well
// The reason why we need this wrapper is that we want to pass to the client the status code and the raw response as well
struct ApiResponse<T: Decodable> {
	let entity: T
	let httpUrlResponse: HTTPURLResponse
	let data: Data?
	
	init(data: Data?, httpUrlResponse: HTTPURLResponse) throws {
		do {
                      self.entity = try JSONDecoder().decode(T.self, from: data ?? Data())
			self.httpUrlResponse = httpUrlResponse
			self.data = data
		} catch {
			throw ApiParseError(error: error, httpUrlResponse: httpUrlResponse, data: data)
		}
	}
}

// Some endpoints might return a 204 No Content
struct VoidResponse: Decodable { }

extension NSError {
	static func createPraseError() -> NSError {
		return NSError(domain: "com.fortech.library",
		               code: ApiParseError.code,
		               userInfo: [NSLocalizedDescriptionKey: "A parsing error occured"])
	}
}
