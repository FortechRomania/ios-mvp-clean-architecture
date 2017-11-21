//
//  ApiClient.swift
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

protocol ApiRequest {
	var urlRequest: URLRequest { get }
}

protocol ApiClient {
	func execute<T>(request: ApiRequest, completionHandler: @escaping (_ result: Result<ApiResponse<T>>) -> Void)
}

protocol URLSessionProtocol {
	func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }

class ApiClientImplementation: ApiClient {
	let urlSession: URLSessionProtocol
	
	init(urlSessionConfiguration: URLSessionConfiguration, completionHandlerQueue: OperationQueue) {
		urlSession = URLSession(configuration: urlSessionConfiguration, delegate: nil, delegateQueue: completionHandlerQueue)
	}
	
	// This should be used mainly for testing purposes
	init(urlSession: URLSessionProtocol) {
		self.urlSession = urlSession
	}
	
	// MARK: - ApiClient
	
	func execute<T>(request: ApiRequest, completionHandler: @escaping (Result<ApiResponse<T>>) -> Void) {
		let dataTask = urlSession.dataTask(with: request.urlRequest) { (data, response, error) in
			guard let httpUrlResponse = response as? HTTPURLResponse else {
				completionHandler(.failure(NetworkRequestError(error: error)))
				return
			}
			
			let successRange = 200...299
			if successRange.contains(httpUrlResponse.statusCode) {
				do {
					let response = try ApiResponse<T>(data: data, httpUrlResponse: httpUrlResponse)
					completionHandler(.success(response))
				} catch {
					completionHandler(.failure(error))
				}
			} else {
				completionHandler(.failure(ApiError(data: data, httpUrlResponse: httpUrlResponse)))
			}
		}
		dataTask.resume()
	}
}
