//
//  DeleteBookUseCaseSpy.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/27/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation
@testable import Library

class DeleteBookUseCaseSpy: DeleteBookUseCase {
	var resultToBeReturned: Result<Void>!
	var callCompletionHandlerImmediate = true
	var bookToDelete: Book?
	
	private var completionHandler: DeleteBookUseCaseCompletionHandler?
	
	func delete(book: Book, completionHandler: @escaping (Result<Void>) -> Void) {
		bookToDelete = book
		self.completionHandler = completionHandler
		
		if callCompletionHandlerImmediate {
			callCompletionHandler()
		}
	}
	
	func callCompletionHandler() {
		self.completionHandler?(resultToBeReturned)
	}
}
