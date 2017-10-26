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

// All entities that model the API responses can implement this so we can handle all responses in a generic way
protocol InitializableWithData {
	init(data: Data?) throws
}

// Optionally, if you use JSON you can implement InitializableWithJson protocol
protocol InitializableWithJson {
	init(json: [String: Any]) throws
}

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
struct ApiResponse<T: InitializableWithData> {
	let entity: T
	let httpUrlResponse: HTTPURLResponse
	let data: Data?
	
	init(data: Data?, httpUrlResponse: HTTPURLResponse) throws {
		do {
			self.entity = try T(data: data)
			self.httpUrlResponse = httpUrlResponse
			self.data = data
		} catch {
			throw ApiParseError(error: error, httpUrlResponse: httpUrlResponse, data: data)
		}
	}
}

// Some endpoints might return a 204 No Content
// We can't have Void implement InitializableWithData so we've created a "Void" response
struct VoidResponse: InitializableWithData {
	init(data: Data?) throws {
		
	}
}

extension Array: InitializableWithData {
	init(data: Data?) throws {
		guard let data = data,
			let jsonObject = try? JSONSerialization.jsonObject(with: data),
			let jsonArray = jsonObject as? [[String: Any]] else {
				throw NSError.createPraseError()
		}
		
		guard let element = Element.self as? InitializableWithJson.Type else {
			throw NSError.createPraseError()
		}
		
		self = try jsonArray.map( { return try element.init(json: $0) as! Element } )
	}
}

extension NSError {
	static func createPraseError() -> NSError {
		return NSError(domain: "com.fortech.library",
		               code: ApiParseError.code,
		               userInfo: [NSLocalizedDescriptionKey: "A parsing error occured"])
	}
}

func dateFrom(_ stringValue: String?) -> Date? {
    guard let value = stringValue else {
        return nil
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.date(from: value)
}
