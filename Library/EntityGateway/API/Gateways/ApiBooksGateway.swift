//
//  ApiBooksGateway.swift
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

// This protocol in not necessarily needed since it doesn't include any extra methods
// besides what BooksGateway already provides. However, if there would be any extra methods
// on the API that we would need to support it would make sense to have an API specific gateway protocol
protocol ApiBooksGateway: BooksGateway {
	
}

class ApiBooksGatewayImplementation: ApiBooksGateway {
	let apiClient: ApiClient
	
	init(apiClient: ApiClient) {
		self.apiClient = apiClient
	}
	
	// MARK: - ApiBooksGateway
	
	func fetchBooks(completionHandler: @escaping (Result<[Book]>) -> Void) {
		let booksApiRequest = BooksApiRequest()
		apiClient.execute(request: booksApiRequest) { (result: Result<ApiResponse<[ApiBook]>>) in
			switch result {
			case let .success(response):
				let books = response.entity.map { return $0.book }
				completionHandler(.success(books))
			case let .failure(error):
				completionHandler(.failure(error))
			}
		}
	}
	
	func add(parameters: AddBookParameters, completionHandler: @escaping (Result<Book>) -> Void) {
		let addBookApiRequest = AddBookApiRequest(addBookParameters: parameters)
		apiClient.execute(request: addBookApiRequest) { (result: Result<ApiResponse<ApiBook>>) in
			switch result {
			case let .success(response):
				let book = response.entity.book
				completionHandler(.success(book))
			case let .failure(error):
				completionHandler(.failure(error))
			}
		}
	}
	
	func delete(book: Book, completionHandler: @escaping (Result<Void>) -> Void) {
		let deleteBookApiRequest = DeleteBookApiRequest(bookId: book.id)
		apiClient.execute(request: deleteBookApiRequest) { (result: Result<ApiResponse<VoidResponse>>) in
			switch result {
			case .success(_):
                completionHandler(.success(()))
			case let .failure(error):
				completionHandler(.failure(error))
			}
		}
	}
	
}
