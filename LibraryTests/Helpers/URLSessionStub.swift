//
//  URLSessionStub.swift
//  Library
//
//  Created by Cosmin Stirbu on 3/2/17.
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

class URLSessionStub: URLSessionProtocol {
	typealias URLSessionCompletionHandlerResponse = (data: Data?, response: URLResponse?, error: Error?)
	var responses = [URLSessionCompletionHandlerResponse]()
	
	func enqueue(response: URLSessionCompletionHandlerResponse) {
		responses.append(response)
	}
	
	func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
		return StubTask(response: responses.removeFirst(), completionHandler: completionHandler)
	}
	
	private class StubTask: URLSessionDataTask {
		let testDoubleResponse: URLSessionCompletionHandlerResponse
		let completionHandler: (Data?, URLResponse?, Error?) -> Void
		
		init(response: URLSessionCompletionHandlerResponse, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
			self.testDoubleResponse = response
			self.completionHandler = completionHandler
		}
		
		override func resume() {
			completionHandler(testDoubleResponse.data, testDoubleResponse.response, testDoubleResponse.error)
		}
	}
}

extension URL {
	static var googleUrl: URL {
		return URL(string: "https://www.google.com")!
	}
}

extension HTTPURLResponse {
	convenience init(statusCode: Int) {
		self.init(url: URL.googleUrl, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
	}
	
}
