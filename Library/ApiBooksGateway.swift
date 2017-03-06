//
//  ApiBooksGateway.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/23/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

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
				completionHandler(.success())
			case let .failure(error):
				completionHandler(.failure(error))
			}
		}
	}
	
}
